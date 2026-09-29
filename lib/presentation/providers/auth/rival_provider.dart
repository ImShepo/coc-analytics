import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/services/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RivalProfileState {
  final String? rivalTag;
  final List<TrophyPoint> points;

  const RivalProfileState({
    this.rivalTag,
    this.points = const [],
  });

  RivalProfileState copyWith({
    String? rivalTag,
    List<TrophyPoint>? points,
    bool clearRival = false,
  }) {
    return RivalProfileState(
      rivalTag: clearRival ? null : (rivalTag ?? this.rivalTag),
      points: points ?? this.points,
    );
  }
}

class RivalProfileNotifier extends StateNotifier<RivalProfileState> {
  RivalProfileNotifier(this._ref) : super(const RivalProfileState()) {
    _ref.listen<AsyncValue<User?>>(authStateProvider, (_, next) {
      final user = next.valueOrNull;
      if (user == null) {
        state = const RivalProfileState();
        return;
      }
      _load(user.uid);
    }, fireImmediately: true);
  }

  final Ref _ref;

  Future<void> _load(String uid) async {
    final local = await _ref.read(userProfileServiceProvider).readLocalRival();
    state = RivalProfileState(rivalTag: local.rivalTag, points: local.points);
    try {
      final remote = await _ref.read(userProfileServiceProvider).fetch(uid);
      if (remote == null) return;
      state = RivalProfileState(
        rivalTag: remote.rivalTag ?? state.rivalTag,
        points: remote.trophyPoints.isNotEmpty ? remote.trophyPoints : state.points,
      );
    } catch (_) {}
  }

  Future<bool> pinRival(String rawTag) async {
    final uid = _ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) return false;
    await _ref.read(userProfileServiceProvider).setRivalTag(uid, rawTag);
    final local = await _ref.read(userProfileServiceProvider).readLocalRival();
    state = state.copyWith(rivalTag: local.rivalTag);
    return true;
  }

  Future<bool> unpinRival() async {
    final uid = _ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) return false;
    await _ref.read(userProfileServiceProvider).clearRivalTag(uid);
    state = state.copyWith(clearRival: true);
    return true;
  }

  Future<void> record(Player player) async {
    final uid = _ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null) return;
    final linked = _ref.read(linkedPlayerTagProvider).valueOrNull;
    if (linked == null || linked.isEmpty) return;
    if (normalizePlayerTag(player.tag) != normalizePlayerTag(linked)) return;
    final points = await _ref.read(userProfileServiceProvider).recordTrophyPoint(
          uid,
          trophies: player.trophies,
          warStars: player.warStars,
          current: state.points,
        );
    state = state.copyWith(points: points);
  }
}

final rivalProfileProvider =
    StateNotifierProvider<RivalProfileNotifier, RivalProfileState>((ref) {
  return RivalProfileNotifier(ref);
});
