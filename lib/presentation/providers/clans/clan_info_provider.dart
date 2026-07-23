import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/repositories/clans_repository.dart';
import 'package:coc/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClanLoadMeta {
  final DateTime? fetchedAt;
  final bool isRefreshing;
  final bool refreshFailed;

  const ClanLoadMeta({
    this.fetchedAt,
    this.isRefreshing = false,
    this.refreshFailed = false,
  });

  static const empty = ClanLoadMeta();
}

class ClanSessionState {
  final Map<String, Clan> byTag;
  final Map<String, ClanLoadMeta> metaByTag;

  const ClanSessionState({
    this.byTag = const {},
    this.metaByTag = const {},
  });

  ClanSessionState copyWith({
    Map<String, Clan>? byTag,
    Map<String, ClanLoadMeta>? metaByTag,
  }) {
    return ClanSessionState(
      byTag: byTag ?? this.byTag,
      metaByTag: metaByTag ?? this.metaByTag,
    );
  }
}

final clanInfoProvider =
    StateNotifierProvider<ClanMapNotifier, ClanSessionState>((ref) {
  final clanRepository = ref.watch(clanRepositoryProvider);
  return ClanMapNotifier(repository: clanRepository);
});

class ClanMapNotifier extends StateNotifier<ClanSessionState> {
  ClanMapNotifier({required ClansRepository repository})
      : _repository = repository,
        super(const ClanSessionState());

  final ClansRepository _repository;
  final Set<String> _inFlight = {};

  Future<void> loadClan(String clanId, {bool force = false}) async {
    final cacheKey = normalizeClanTag(clanId);
    if (cacheKey.isEmpty) return;
    if (_inFlight.contains(cacheKey)) return;

    final meta = state.metaByTag[cacheKey];
    _inFlight.add(cacheKey);
    try {
      final cached =
          state.byTag[cacheKey] ?? await _repository.readCachedClan(cacheKey);
      final cachedAt =
          await _repository.clanCacheTimestamp(cacheKey) ?? DateTime.now();
      if (cached != null) {
        state = state.copyWith(
          byTag: {...state.byTag, cacheKey: cached},
          metaByTag: {
            ...state.metaByTag,
            cacheKey: ClanLoadMeta(
              fetchedAt: cachedAt,
              isRefreshing: true,
            ),
          },
        );
      } else {
        state = state.copyWith(
          metaByTag: {
            ...state.metaByTag,
            cacheKey: const ClanLoadMeta(isRefreshing: true),
          },
        );
      }

      final clan = await _repository.refreshClan(cacheKey);
      state = state.copyWith(
        byTag: {...state.byTag, cacheKey: clan},
        metaByTag: {
          ...state.metaByTag,
          cacheKey: ClanLoadMeta(
            fetchedAt: DateTime.now(),
            isRefreshing: false,
          ),
        },
      );
    } catch (_) {
      final hasStale = state.byTag[cacheKey] != null;
      state = state.copyWith(
        metaByTag: {
          ...state.metaByTag,
          cacheKey: ClanLoadMeta(
            fetchedAt: meta?.fetchedAt,
            isRefreshing: false,
            refreshFailed: hasStale,
          ),
        },
      );
    } finally {
      _inFlight.remove(cacheKey);
    }
  }

  Future<void> refreshClan(String clanId) =>
      loadClan(clanId, force: true);

  Future<void> clearAll() async {
    _inFlight.clear();
    state = const ClanSessionState();
    await _repository.invalidateClanCache();
  }
}
