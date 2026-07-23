import 'package:coc/config/helpers/clan_tag.dart';
import 'package:coc/domain/datasources/clans_datasource.dart';
import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/clan_war_log.dart';
import 'package:coc/domain/repositories/clans_repository.dart';
import 'package:coc/infrastructure/cache/cache_policy.dart';
import 'package:coc/infrastructure/cache/disk_entity_cache.dart';
import 'package:coc/infrastructure/cache/memory_cache.dart';
import 'package:coc/infrastructure/mappers/clan_mapper.dart';
import 'package:coc/infrastructure/models/clandb/clan_details.dart';

class ClanRepositoryImpl extends ClansRepository {
  final ClansDatasource datasource;
  static final _clanCache = MemoryCache<Clan>(ttl: CachePolicy.memoryTtl);
  static final _clanDisk = DiskEntityCache('coc_clan_v1_');
  static final _searchCache = MemoryCache<List<Clan>>();
  static final _warLogCache = MemoryCache<List<ClanWarLogEntry>>();
  static final _raidCache = MemoryCache<List<CapitalRaidSeason>>();

  ClanRepositoryImpl(this.datasource);

  @override
  Future<Clan> getClanById(String id) async {
    final cacheKey = normalizeClanTag(id);
    final cached = _clanCache.get(cacheKey);
    if (cached != null) return cached;
    return refreshClan(id);
  }

  @override
  Future<Clan?> readCachedClan(String id) async {
    final cacheKey = normalizeClanTag(id);
    final memory = _clanCache.get(cacheKey);
    if (memory != null) return memory;

    final disk = await _clanDisk.read(cacheKey);
    if (disk == null) return null;

    try {
      final details = ClanDetails.fromJson(disk.payload);
      final clan = ClanMapper.clanDetailsToEntity(details);
      _clanCache.set(cacheKey, clan);
      return clan;
    } catch (_) {
      await _clanDisk.remove(cacheKey);
      return null;
    }
  }

  @override
  Future<Clan> refreshClan(String id) async {
    final cacheKey = normalizeClanTag(id);
    final payload = await datasource.fetchClanPayload(id);
    await _clanDisk.write(cacheKey, payload);
    final details = ClanDetails.fromJson(payload);
    final clan = ClanMapper.clanDetailsToEntity(details);
    _clanCache.set(cacheKey, clan);
    return clan;
  }

  @override
  Future<DateTime?> clanCacheTimestamp(String id) async {
    final cacheKey = normalizeClanTag(id);
    return (await _clanDisk.read(cacheKey))?.fetchedAt;
  }

  @override
  Future<void> invalidateClanCache([String? id]) async {
    if (id == null) {
      _clanCache.clear();
      await _clanDisk.clearAll();
      return;
    }
    final cacheKey = normalizeClanTag(id);
    _clanCache.remove(cacheKey);
    await _clanDisk.remove(cacheKey);
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

  @override
  Future<List<ClanWarLogEntry>> getWarLog(
    String clanTag, {
    int limit = 20,
  }) async {
    final cacheKey = '${normalizeClanTag(clanTag)}|$limit';
    final cached = _warLogCache.get(cacheKey);
    if (cached != null) return cached;

    final entries = await datasource.getWarLog(clanTag, limit: limit);
    _warLogCache.set(cacheKey, entries);
    return entries;
  }

  @override
  Future<List<CapitalRaidSeason>> getCapitalRaidSeasons(
    String clanTag, {
    int limit = 10,
  }) async {
    final cacheKey = '${normalizeClanTag(clanTag)}|$limit';
    final cached = _raidCache.get(cacheKey);
    if (cached != null) return cached;

    final seasons =
        await datasource.getCapitalRaidSeasons(clanTag, limit: limit);
    _raidCache.set(cacheKey, seasons);
    return seasons;
  }
}
