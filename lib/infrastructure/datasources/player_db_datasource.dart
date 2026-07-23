import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/config/helpers/player_tag.dart';
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
      final payload = await fetchPlayerPayload(id);
      final playerResponse = PlayerResponse.fromJson(payload);
      return PlayerMapper.playerResponseToEntity(playerResponse);
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    } catch (e) {
      throw apiExceptionFromObject(e);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPlayerPayload(String id) async {
    try {
      final tag = normalizePlayerTag(id);
      final response = await dio.get(
        '/players/${Uri.encodeComponent('#$tag')}',
      );
      if (response.statusCode != 200) {
        throw apiExceptionFromStatusCode(response.statusCode ?? 500);
      }
      return Map<String, dynamic>.from(response.data as Map);
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    } catch (e) {
      throw apiExceptionFromObject(e);
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

  @override
  Future<bool> verifyPlayerToken(String id, String apiToken) async {
    final token = apiToken
        .trim()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '');
    if (token.isEmpty) {
      throw 'Introduce el token de API del juego.';
    }

    final tag = id.replaceAll('#', '').trim().toUpperCase();
    if (tag.isEmpty) {
      throw 'Introduce tu etiqueta de jugador.';
    }

    try {
      final response = await dio.post(
        '/players/${Uri.encodeComponent('#$tag')}/verifytoken',
        data: {'token': token},
      );
      final data = response.data;
      if (data is Map && data['status'] == 'ok') {
        return true;
      }
      return false;
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      throw apiExceptionFromDio(e);
    } catch (e) {
      throw apiExceptionFromObject(e);
    }
  }
}
