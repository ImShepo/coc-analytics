import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clanInfoProvider =
    StateNotifierProvider<ClanMapNotifier, Map<String, Clan>>((ref) {
  final clanRepository = ref.watch(clanRepositoryProvider);
  return ClanMapNotifier(getClan: clanRepository.getClanById);
});

typedef GetClanCallback = Future<Clan> Function(String clanId);

class ClanMapNotifier extends StateNotifier<Map<String, Clan>> {
  final GetClanCallback getClan;
  final Set<String> _loading = {};

  ClanMapNotifier({
    required this.getClan,
  }) : super({});

  Future<void> loadClan(String clanId) async {
    final cacheKey = normalizeClanTag(clanId);
    if (cacheKey.isEmpty) return;
    if (state[cacheKey] != null || _loading.contains(cacheKey)) return;

    _loading.add(cacheKey);
    try {
      final clan = await getClan(cacheKey);
      state = {...state, cacheKey: clan};
    } finally {
      _loading.remove(cacheKey);
    }
  }
}
