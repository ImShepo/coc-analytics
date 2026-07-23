import 'package:coc/presentation/providers/clans/clan_info_provider.dart';
import 'package:coc/presentation/providers/players/player_provider.dart';
import 'package:coc/services/auth_service.dart';
import 'package:coc/services/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasSeenWelcomeKey = 'has_seen_welcome';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final userProfileServiceProvider =
    Provider<UserProfileService>((ref) => UserProfileService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

/// Welcome (post-install) is shown only once; afterwards signed-out users go to login.
final hasSeenWelcomeProvider =
    StateNotifierProvider<HasSeenWelcomeNotifier, AsyncValue<bool>>((ref) {
  final notifier = HasSeenWelcomeNotifier();
  ref.listen<AsyncValue<User?>>(authStateProvider, (_, next) {
    final user = next.valueOrNull;
    if (user != null) {
      notifier.markSeen();
    }
  });
  return notifier;
});

class HasSeenWelcomeNotifier extends StateNotifier<AsyncValue<bool>> {
  HasSeenWelcomeNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = AsyncValue.data(prefs.getBool(_hasSeenWelcomeKey) ?? false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markSeen() async {
    if (state.valueOrNull == true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenWelcomeKey, true);
    state = const AsyncValue.data(true);
  }
}

final linkedPlayerTagProvider =
    StateNotifierProvider<LinkedPlayerTagNotifier, AsyncValue<String?>>((ref) {
  final notifier = LinkedPlayerTagNotifier(ref);
  ref.listen<AsyncValue<User?>>(authStateProvider, (_, next) {
    next.when(
      data: notifier.onAuthUserChanged,
      loading: () {},
      error: (_, __) => notifier.onAuthUserChanged(null),
    );
  }, fireImmediately: true);
  return notifier;
});

class LinkedPlayerTagNotifier extends StateNotifier<AsyncValue<String?>> {
  LinkedPlayerTagNotifier(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;
  String? _uid;
  int _bindGeneration = 0;

  Future<void> onAuthUserChanged(User? user) async {
    final generation = ++_bindGeneration;
    _uid = user?.uid;

    if (user == null) {
      // Local session only — server profile is kept for the next sign-in.
      state = const AsyncValue.data(null);
      await _ref.read(linkDeferredProvider.notifier).syncFromProfile(false);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final profile =
          await _ref.read(userProfileServiceProvider).loadAndMigrate(user.uid);
      if (generation != _bindGeneration) return;
      state = AsyncValue.data(profile.linkedPlayerTag);
      await _ref
          .read(linkDeferredProvider.notifier)
          .syncFromProfile(profile.linkDeferred);
    } catch (e, st) {
      if (generation != _bindGeneration) return;
      // Never block login on profile/Firestore errors.
      debugPrint('linkedPlayerTag load failed: $e\n$st');
      state = const AsyncValue.data(null);
      await _ref.read(linkDeferredProvider.notifier).syncFromProfile(false);
    }
  }

  Future<void> setTag(String rawTag) async {
    final uid = _uid ?? _ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) {
      throw StateError('Cannot link a player without a signed-in user.');
    }

    final normalized = AuthService.playerTagForStorage(rawTag);
    await _ref.read(playerProvider.notifier).clearAll();
    await _ref.read(clanInfoProvider.notifier).clearAll();
    await _ref.read(userProfileServiceProvider).setLinkedPlayerTag(uid, normalized);
    state = AsyncValue.data(normalized);
    await _ref.read(linkDeferredProvider.notifier).syncFromProfile(false);
  }

  /// Removes the Clash player link on the server (explicit unlink only).
  Future<void> clear() async {
    final uid = _uid ?? _ref.read(authStateProvider).valueOrNull?.uid;
    await _ref.read(playerProvider.notifier).clearAll();
    await _ref.read(clanInfoProvider.notifier).clearAll();
    if (uid != null) {
      await _ref.read(userProfileServiceProvider).clearLinkedPlayerTag(uid);
    }
    state = const AsyncValue.data(null);
  }
}

/// When true, the user skipped linking and can browse without a CoC tag.
final linkDeferredProvider =
    StateNotifierProvider<LinkDeferredNotifier, AsyncValue<bool>>((ref) {
  return LinkDeferredNotifier(ref);
});

class LinkDeferredNotifier extends StateNotifier<AsyncValue<bool>> {
  LinkDeferredNotifier(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;

  /// Called when the signed-in profile is loaded (or after sign-out → false).
  Future<void> syncFromProfile(bool deferred) async {
    state = AsyncValue.data(deferred);
  }

  Future<void> defer() async {
    final uid = _ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) {
      throw StateError('Cannot defer linking without a signed-in user.');
    }
    await _ref.read(userProfileServiceProvider).setLinkDeferred(uid, true);
    state = const AsyncValue.data(true);
  }

  Future<void> clear() async {
    final uid = _ref.read(authStateProvider).valueOrNull?.uid;
    if (uid != null) {
      await _ref.read(userProfileServiceProvider).setLinkDeferred(uid, false);
    }
    state = const AsyncValue.data(false);
  }
}

/// Notifies [GoRouter] when auth or linked-tag state changes.
class AuthRouterRefresh extends ChangeNotifier {
  AuthRouterRefresh(Ref ref) {
    _authSub = ref.listen<AsyncValue<User?>>(authStateProvider, (_, __) {
      notifyListeners();
    });
    _tagSub =
        ref.listen<AsyncValue<String?>>(linkedPlayerTagProvider, (_, __) {
      notifyListeners();
    });
    _deferredSub =
        ref.listen<AsyncValue<bool>>(linkDeferredProvider, (_, __) {
      notifyListeners();
    });
    _welcomeSub =
        ref.listen<AsyncValue<bool>>(hasSeenWelcomeProvider, (_, __) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<AsyncValue<User?>> _authSub;
  late final ProviderSubscription<AsyncValue<String?>> _tagSub;
  late final ProviderSubscription<AsyncValue<bool>> _deferredSub;
  late final ProviderSubscription<AsyncValue<bool>> _welcomeSub;

  @override
  void dispose() {
    _authSub.close();
    _tagSub.close();
    _deferredSub.close();
    _welcomeSub.close();
    super.dispose();
  }
}

final authRouterRefreshProvider = Provider<AuthRouterRefresh>((ref) {
  final refresh = AuthRouterRefresh(ref);
  ref.onDispose(refresh.dispose);
  return refresh;
});
