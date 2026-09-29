import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/clan_war_log.dart';
import 'package:coc/domain/entities/current_clan_war.dart';

abstract class ClansRepository {
  Future<Clan> getClanById(String id);

  Future<Clan?> readCachedClan(String id);

  Future<Clan> refreshClan(String id);

  Future<DateTime?> clanCacheTimestamp(String id);

  Future<void> invalidateClanCache([String? id]);

  Future<List<Clan>> searchClans(String query);

  Future<List<ClanWarLogEntry>> getWarLog(String clanTag, {int limit = 20});

  Future<List<CapitalRaidSeason>> getCapitalRaidSeasons(
    String clanTag, {
    int limit = 10,
  });

  /// [force] skips the 60s memory cache. Never written to disk.
  Future<CurrentClanWar> getCurrentWar(String clanTag, {bool force = false});
}
