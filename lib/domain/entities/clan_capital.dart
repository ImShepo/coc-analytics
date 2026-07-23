class ClanCapitalDistrict {
  final int id;
  final String name;
  final int districtHallLevel;

  const ClanCapitalDistrict({
    required this.id,
    required this.name,
    required this.districtHallLevel,
  });
}

class ClanCapital {
  final int capitalHallLevel;
  final List<ClanCapitalDistrict> districts;

  const ClanCapital({
    this.capitalHallLevel = 0,
    this.districts = const [],
  });

  bool get hasData => capitalHallLevel > 0 || districts.isNotEmpty;
}
