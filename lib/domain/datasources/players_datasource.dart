import 'package:coc/domain/entities/player.dart';
import 'package:coc/domain/entities/player_by_clan.dart';

abstract class PlayersDatasource {
  Future<Player> getPlayerById(String id);

  Future<Map<String, dynamic>> fetchPlayerPayload(String id);

  Future<List<PlayerByClan>> getPlayersByClan(String clanId);

  /// Returns true when Supercell confirms the in-game API token for [id].
  Future<bool> verifyPlayerToken(String id, String apiToken);
}