import 'package:coc/config/helpers/building_catalog.dart';
import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:dio/dio.dart';

class UnitStaticRepository {
  UnitStaticRepository._();

  static final UnitStaticRepository instance = UnitStaticRepository._();

  static const _url = 'https://assets.clashk.ing/static_data.json';

  final Dio _dio = Dio();
  Map<String, dynamic>? _data;
  Future<Map<String, dynamic>>? _loading;

  Future<Map<String, dynamic>> load() {
    return _loading ??= _fetch();
  }

  Future<Map<String, dynamic>> _fetch() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _url,
        options: Options(responseType: ResponseType.json),
      );
      _data = response.data;
      return _data ?? {};
    } catch (_) {
      _data = {};
      return {};
    }
  }

  Map<String, dynamic>? findFor(CategoryUnit unit) {
    final data = _data;
    if (data == null) return null;

    if (unit.displayImageName == 'Long Shot') {
      final guardians = data['guardians'];
      if (guardians is List) {
        for (final item in guardians) {
          if (item is Map<String, dynamic> && item['name'] == 'Longshot') {
            return item;
          }
        }
      }
    }

    final collection = _collectionFor(unit);
    if (collection == null) return null;

    final items = data[collection];
    if (items is! List) return null;

    final lookupName = _lookupName(unit);
    for (final item in items) {
      if (item is! Map<String, dynamic>) continue;
      if (item['name'] != lookupName) continue;
      if (!_villageMatches(item, unit)) continue;
      return item;
    }
    return null;
  }

  String? _collectionFor(CategoryUnit unit) => switch (unit.category) {
        UnitCategory.troop =>
          unit.troopGroup == TroopGroup.pet ? 'pets' : 'troops',
        UnitCategory.hero => 'heroes',
        UnitCategory.spell => 'spells',
        UnitCategory.equipment => 'equipment',
        UnitCategory.building =>
          unit.buildingGroup == BuildingGroup.traps ? 'traps' : 'buildings',
      };

  String _lookupName(CategoryUnit unit) {
    if (unit.category == UnitCategory.building ||
        unit.buildingGroup == BuildingGroup.traps) {
      return unit.displayImageName;
    }
    return unit.name;
  }

  bool _villageMatches(Map<String, dynamic> item, CategoryUnit unit) {
    final itemVillage = item['village'] as String?;
    if (itemVillage == null) return true;
    return itemVillage == unit.village;
  }

  List<Map<String, dynamic>> levelsFor(Map<String, dynamic> item) {
    final levels = item['levels'];
    if (levels is! List) return [];
    return levels.whereType<Map<String, dynamic>>().toList();
  }

  Map<String, dynamic>? levelAt(Map<String, dynamic> item, int level) {
    for (final entry in levelsFor(item)) {
      if (entry['level'] == level) return entry;
    }
    return null;
  }

  int maxLevelAtTownHall(Map<String, dynamic> item, int townHall) {
    var max = 0;
    for (final entry in levelsFor(item)) {
      final required = entry['required_townhall'] as int? ?? 0;
      if (required <= townHall) {
        max = entry['level'] as int? ?? max;
      }
    }
    return max;
  }

  int unlockTownHall(Map<String, dynamic> item) {
    final first = levelsFor(item).firstOrNull;
    return first?['required_townhall'] as int? ?? 1;
  }

  int? housingSpace(Map<String, dynamic> item) =>
      item['housing_space'] as int?;
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
