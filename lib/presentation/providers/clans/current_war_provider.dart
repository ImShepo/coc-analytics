import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/domain/entities/current_clan_war.dart';
import 'package:coc/domain/repositories/clans_repository.dart';
import 'package:coc/presentation/providers/clans/clans_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentWarSession {
  final Map<String, AsyncValue<CurrentClanWar>> byTag;

  const CurrentWarSession({this.byTag = const {}});

  CurrentWarSession copyWith({
    Map<String, AsyncValue<CurrentClanWar>>? byTag,
  }) {
    return CurrentWarSession(byTag: byTag ?? this.byTag);
  }
}

class CurrentWarNotifier extends StateNotifier<CurrentWarSession> {
  CurrentWarNotifier(this._repository) : super(const CurrentWarSession());

  final ClansRepository _repository;
  final Set<String> _inFlight = {};

  Future<void> load(String clanTag, {bool force = false}) async {
    final id = normalizeClanTag(clanTag);
    if (id.isEmpty || _inFlight.contains(id)) return;

    final previous = state.byTag[id];
    if (!force && previous != null && previous.isLoading) return;

    _inFlight.add(id);
    if (previous == null || !previous.hasValue) {
      state = state.copyWith(
        byTag: {...state.byTag, id: const AsyncValue.loading()},
      );
    }

    try {
      final war = await _repository.getCurrentWar(id, force: force);
      state = state.copyWith(
        byTag: {...state.byTag, id: AsyncValue.data(war)},
      );
    } catch (error, stackTrace) {
      if (previous?.hasValue == true) {
        state = state.copyWith(byTag: {...state.byTag, id: previous!});
      } else {
        state = state.copyWith(
          byTag: {...state.byTag, id: AsyncValue.error(error, stackTrace)},
        );
      }
    } finally {
      _inFlight.remove(id);
    }
  }
}

final currentWarProvider =
    StateNotifierProvider<CurrentWarNotifier, CurrentWarSession>((ref) {
  return CurrentWarNotifier(ref.watch(clanRepositoryProvider));
});
