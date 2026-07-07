import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/helpers/errors.dart';
import 'package:coc/domain/datasources/players_datasource.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/domain/entities/player_by_clan.dart';
import 'package:coc/infrastructure/mappers/clan_mapper.dart';
import 'package:coc/infrastructure/mappers/player_by_clan_mapper.dart';
import 'package:coc/infrastructure/mappers/player_mapper.dart';
import 'package:coc/infrastructure/models/clandb/clan_details.dart';
import 'package:coc/infrastructure/models/playersdb/player_db_response.dart';
import 'package:coc/infrastructure/network/dio_client.dart';
import 'package:dio/dio.dart';

class PlayerDBDatasource extends PlayersDatasource {
  final dio = DioClient.instance;

  @override
  Future<Player> getPlayerById(String id) async {
    try {
      final response = await dio.get('/players/%23$id');
      if (response.statusCode != 200) {
        throw handleDioException(response.statusCode!);
      }

      final playerResponse = PlayerResponse.fromJson(response.data);
      final Player player = PlayerMapper.playerResponseToEntity(playerResponse);
      return player;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        throw data['message'] as String;
      }
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        throw handleDioException(statusCode);
      }
      throw 'Error de conexión. Revisa tu internet.';
    }
  }

  @override
  Future<List<PlayerByClan>> getPlayersByClan(String clanId) async {
    final response =
        await dio.get('/clans/${clanTagToApiPath(clanId)}');

    final clanDetails = ClanDetails.fromJson(response.data);

    List<PlayerByClan> players = clanDetails.memberList
        .map((member) => PlayerByClanMapper.playerResponseToEntity(
            ClanMapper.memberListDetailsToEntity(member)))
        .toList();

    return players;
  }
}
