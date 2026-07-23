import 'package:coc/domain/entities/player.dart';
import 'package:coc/domain/entities/player_by_clan.dart';

abstract class PlayersRepository {
  Future<Player> getPlayerById(String id);

  /// Last on-device snapshot, if any.
  Future<Player?> readCachedPlayer(String id);

  /// Network fetch; updates memory + disk caches.
  Future<Player> refreshPlayer(String id);

  Future<DateTime?> playerCacheTimestamp(String id);

  Future<void> invalidatePlayerCache([String? id]);

  Future<List<PlayerByClan>> getPlayersByClan(String clanId);

  Future<bool> verifyPlayerToken(String id, String apiToken);
}