import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/domain/datasources/clans_datasource.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/repositories/clans_repository.dart';
import 'package:coc/infrastructure/cache/memory_cache.dart';

class ClanRepositoryImpl extends ClansRepository {
  final ClansDatasource datasource;
  static final _clanCache = MemoryCache<Clan>();
  static final _searchCache = MemoryCache<List<Clan>>();

  ClanRepositoryImpl(this.datasource);

  @override
  Future<Clan> getClanById(String id) async {
    final cacheKey = normalizeClanTag(id);
    final cached = _clanCache.get(cacheKey);
    if (cached != null) return cached;

    final clan = await datasource.getClanById(id);
    _clanCache.set(cacheKey, clan);
    return clan;
  }

  @override
  Future<List<Clan>> searchClans(String query) async {
    final normalizedQuery = query.trim().toLowerCase();
    final cached = _searchCache.get(normalizedQuery);
    if (cached != null) return cached;

    final clans = await datasource.searchClans(query);
    _searchCache.set(normalizedQuery, clans);
    return clans;
  }
}
