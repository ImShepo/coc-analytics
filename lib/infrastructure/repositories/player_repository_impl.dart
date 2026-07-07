import 'package:coc/domain/datasources/players_datasource.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/domain/entities/player_by_clan.dart';
import 'package:coc/domain/repositories/players_repository.dart';
import 'package:coc/infrastructure/cache/memory_cache.dart';

class PlayerRepositoryImpl extends PlayersRepository {
  final PlayersDatasource datasource;
  static final _cache = MemoryCache<Player>();

  PlayerRepositoryImpl(this.datasource);

  @override
  Future<Player> getPlayerById(String id) async {
    final cached = _cache.get(id);
    if (cached != null) return cached;

    final player = await datasource.getPlayerById(id);
    _cache.set(id, player);
    return player;
  }

  @override
  Future<List<PlayerByClan>> getPlayersByClan(String clanId) {
    return datasource.getPlayersByClan(clanId);
  }
}
