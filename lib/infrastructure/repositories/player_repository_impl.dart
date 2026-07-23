import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/domain/datasources/players_datasource.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/domain/entities/player_by_clan.dart';
import 'package:coc/domain/repositories/players_repository.dart';
import 'package:coc/infrastructure/cache/cache_policy.dart';
import 'package:coc/infrastructure/cache/disk_entity_cache.dart';
import 'package:coc/infrastructure/cache/memory_cache.dart';
import 'package:coc/infrastructure/mappers/player_mapper.dart';
import 'package:coc/infrastructure/models/playersdb/player_db_response.dart';

class PlayerRepositoryImpl extends PlayersRepository {
  final PlayersDatasource datasource;
  static final _cache = MemoryCache<Player>(ttl: CachePolicy.memoryTtl);
  static final _disk = DiskEntityCache('coc_player_v1_');

  PlayerRepositoryImpl(this.datasource);

  @override
  Future<Player> getPlayerById(String id) async {
    final key = normalizePlayerTag(id);
    final cached = _cache.get(key);
    if (cached != null) return cached;
    return refreshPlayer(id);
  }

  @override
  Future<Player?> readCachedPlayer(String id) async {
    final key = normalizePlayerTag(id);
    final memory = _cache.get(key);
    if (memory != null) return memory;

    final disk = await _disk.read(key);
    if (disk == null) return null;

    try {
      final response = PlayerResponse.fromJson(disk.payload);
      final player = PlayerMapper.playerResponseToEntity(response);
      _cache.set(key, player);
      return player;
    } catch (_) {
      await _disk.remove(key);
      return null;
    }
  }

  @override
  Future<Player> refreshPlayer(String id) async {
    final key = normalizePlayerTag(id);
    final payload = await datasource.fetchPlayerPayload(id);
    await _disk.write(key, payload);
    final response = PlayerResponse.fromJson(payload);
    final player = PlayerMapper.playerResponseToEntity(response);
    _cache.set(key, player);
    return player;
  }

  @override
  Future<DateTime?> playerCacheTimestamp(String id) async {
    final key = normalizePlayerTag(id);
    return (await _disk.read(key))?.fetchedAt;
  }

  @override
  Future<void> invalidatePlayerCache([String? id]) async {
    if (id == null) {
      _cache.clear();
      await _disk.clearAll();
      return;
    }
    final key = normalizePlayerTag(id);
    _cache.remove(key);
    await _disk.remove(key);
  }

  @override
  Future<List<PlayerByClan>> getPlayersByClan(String clanId) {
    return datasource.getPlayersByClan(clanId);
  }

  @override
  Future<bool> verifyPlayerToken(String id, String apiToken) {
    return datasource.verifyPlayerToken(id, apiToken);
  }
}
