import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/domain/datasources/clans_datasource.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/clan_war_log.dart';
import 'package:coc/infrastructure/mappers/clan_mapper.dart';
import 'package:coc/infrastructure/models/clandb/clan_db_response.dart';
import 'package:coc/infrastructure/models/clandb/clan_details.dart';
import 'package:coc/infrastructure/models/clandb/clan_war_models.dart';
import 'package:coc/infrastructure/network/dio_client.dart';

class ClanDBDatasource extends ClansDatasource {
  final dio = DioClient.instance;

  List<Clan> _jsonToClans(Map<String, dynamic> json) {
    final clanDBResponse = ClanDBResponse.fromJson(json);
    final List<Clan> clans = clanDBResponse.items
        .map((clanDB) => ClanMapper.clanDBToEntity(clanDB))
        .toList();

    return clans;
  }

  @override
  Future<Clan> getClanById(String id) async {
    final response = await dio.get('/clans/${clanTagToApiPath(id)}');
    if (response.statusCode != 200) {
      throw Exception('Clan with id: $id not found');
    }

    final clanDetails = ClanDetails.fromJson(response.data);
    return ClanMapper.clanDetailsToEntity(clanDetails);
  }

  @override
  Future<Map<String, dynamic>> fetchClanPayload(String id) async {
    final response = await dio.get('/clans/${clanTagToApiPath(id)}');
    if (response.statusCode != 200) {
      throw Exception('Clan with id: $id not found');
    }
    return Map<String, dynamic>.from(response.data as Map);
  }

  @override
  Future<List<Clan>> searchClans(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    // Tag lookup requires the leading # (documented in the search hint).
    if (trimmed.startsWith('#')) {
      try {
        return [await getClanById(trimmed)];
      } catch (_) {
        return [];
      }
    }

    if (trimmed.length < 3) return [];

    final response =
        await dio.get('/clans', queryParameters: {'name': trimmed});

    return _jsonToClans(response.data);
  }

  @override
  Future<List<ClanWarLogEntry>> getWarLog(
    String clanTag, {
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/clans/${clanTagToApiPath(clanTag)}/warlog',
      queryParameters: {'limit': limit},
    );
    if (response.statusCode != 200) {
      throw Exception('War log unavailable');
    }
    return ClanWarLogResponse.fromJson(
      response.data as Map<String, dynamic>,
    ).items;
  }

  @override
  Future<List<CapitalRaidSeason>> getCapitalRaidSeasons(
    String clanTag, {
    int limit = 10,
  }) async {
    final response = await dio.get(
      '/clans/${clanTagToApiPath(clanTag)}/capitalraidseasons',
      queryParameters: {'limit': limit},
    );
    if (response.statusCode != 200) {
      throw Exception('Capital raid seasons unavailable');
    }
    return CapitalRaidSeasonsResponse.fromJson(
      response.data as Map<String, dynamic>,
    ).items;
  }
}
