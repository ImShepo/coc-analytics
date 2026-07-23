import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/domain/repositories/players_repository.dart';
import 'package:coc/presentation/providers/players/players_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerLoadMeta {
  final DateTime? fetchedAt;
  final bool isRefreshing;
  final bool refreshFailed;

  const PlayerLoadMeta({
    this.fetchedAt,
    this.isRefreshing = false,
    this.refreshFailed = false,
  });

  static const empty = PlayerLoadMeta();
}

class PlayerSessionState {
  final Map<String, AsyncValue<Player>> byTag;
  final Map<String, PlayerLoadMeta> metaByTag;

  const PlayerSessionState({
    this.byTag = const {},
    this.metaByTag = const {},
  });

  PlayerSessionState copyWith({
    Map<String, AsyncValue<Player>>? byTag,
    Map<String, PlayerLoadMeta>? metaByTag,
  }) {
    return PlayerSessionState(
      byTag: byTag ?? this.byTag,
      metaByTag: metaByTag ?? this.metaByTag,
    );
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerSessionState>((ref) {
  final repository = ref.watch(playersRepositoryProvider);
  return PlayerNotifier(repository: repository);
});

class PlayerNotifier extends StateNotifier<PlayerSessionState> {
  PlayerNotifier({required PlayersRepository repository})
      : _repository = repository,
        super(const PlayerSessionState());

  final PlayersRepository _repository;
  final Set<String> _inFlight = {};

  Future<void> loadPlayer(String playerId, {bool force = false}) async {
    final id = normalizePlayerTag(playerId);
    if (_inFlight.contains(id)) return;

    final current = state.byTag[id];
    if (!force && current != null && current.isLoading) return;

    _inFlight.add(id);
    try {
      if (!force) {
        final cached = await _repository.readCachedPlayer(id);
        final cachedAt =
            await _repository.playerCacheTimestamp(id) ?? DateTime.now();
        if (cached != null) {
          state = state.copyWith(
            byTag: {...state.byTag, id: AsyncValue.data(cached)},
            metaByTag: {
              ...state.metaByTag,
              id: PlayerLoadMeta(
                fetchedAt: cachedAt,
                isRefreshing: true,
              ),
            },
          );
        } else if (current == null || !current.hasValue) {
          state = state.copyWith(
            byTag: {...state.byTag, id: const AsyncValue.loading()},
          );
        } else {
          state = state.copyWith(
            metaByTag: {
              ...state.metaByTag,
              id: PlayerLoadMeta(
                fetchedAt: state.metaByTag[id]?.fetchedAt,
                isRefreshing: true,
              ),
            },
          );
        }
      } else if (current?.hasValue == true) {
        state = state.copyWith(
          metaByTag: {
            ...state.metaByTag,
            id: PlayerLoadMeta(
              fetchedAt: state.metaByTag[id]?.fetchedAt,
              isRefreshing: true,
            ),
          },
        );
      } else {
        state = state.copyWith(
          byTag: {...state.byTag, id: const AsyncValue.loading()},
        );
      }

      final player = await _repository.refreshPlayer(id);
      state = state.copyWith(
        byTag: {...state.byTag, id: AsyncValue.data(player)},
        metaByTag: {
          ...state.metaByTag,
          id: PlayerLoadMeta(
            fetchedAt: DateTime.now(),
            isRefreshing: false,
            refreshFailed: false,
          ),
        },
      );
    } catch (error, stackTrace) {
      final hasStale = state.byTag[id]?.hasValue == true;
      if (hasStale) {
        state = state.copyWith(
          metaByTag: {
            ...state.metaByTag,
            id: PlayerLoadMeta(
              fetchedAt: state.metaByTag[id]?.fetchedAt,
              isRefreshing: false,
              refreshFailed: true,
            ),
          },
        );
      } else {
        state = state.copyWith(
          byTag: {...state.byTag, id: AsyncValue.error(error, stackTrace)},
          metaByTag: {
            ...state.metaByTag,
            id: const PlayerLoadMeta(refreshFailed: true),
          },
        );
      }
    } finally {
      _inFlight.remove(id);
    }
  }

  Future<void> clearAll() async {
    _inFlight.clear();
    state = const PlayerSessionState();
    await _repository.invalidatePlayerCache();
  }

  Future<void> invalidateTag(String playerId) async {
    final id = normalizePlayerTag(playerId);
    _inFlight.remove(id);
    final nextByTag = Map<String, AsyncValue<Player>>.from(state.byTag)
      ..remove(id);
    final nextMeta = Map<String, PlayerLoadMeta>.from(state.metaByTag)
      ..remove(id);
    state = state.copyWith(byTag: nextByTag, metaByTag: nextMeta);
    await _repository.invalidatePlayerCache(id);
  }
}
