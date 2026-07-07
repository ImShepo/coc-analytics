import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/domain/datasources/clans_datasource.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/infrastructure/mappers/clan_mapper.dart';
import 'package:coc/infrastructure/models/clandb/clan_db_response.dart';
import 'package:coc/infrastructure/models/clandb/clan_details.dart';
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
    final Clan clan = ClanMapper.clanDetailsToEntity(clanDetails);
    return clan;
  }

  @override
  Future<List<Clan>> searchClans(String query) async {
    if (query.isEmpty || query.length < 3) return [];

    final response = await dio.get('/clans', queryParameters: {'name': query});

    return _jsonToClans(response.data);
  }
}
