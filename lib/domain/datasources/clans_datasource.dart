import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/clan_war_log.dart';

abstract class ClansDatasource {
  Future<Clan> getClanById(String id);

  Future<Map<String, dynamic>> fetchClanPayload(String id);

  Future<List<Clan>> searchClans(String query);

  Future<List<ClanWarLogEntry>> getWarLog(String clanTag, {int limit = 20});

  Future<List<CapitalRaidSeason>> getCapitalRaidSeasons(
    String clanTag, {
    int limit = 10,
  });
}
