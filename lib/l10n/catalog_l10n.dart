import 'package:coc/config/helpers/building_catalog.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/l10n/app_localizations.dart';

extension CatalogL10n on AppLocalizations {
  String troopGroupLabel(TroopGroup group) => switch (group) {
        TroopGroup.elixir => troopGroupElixir,
        TroopGroup.darkElixir => troopGroupDarkElixir,
        TroopGroup.builderBase => troopGroupBuilderBase,
        TroopGroup.siege => troopGroupSiege,
        TroopGroup.pet => troopGroupPets,
        TroopGroup.other => troopGroupOther,
      };

  String spellGroupLabel(SpellGroup group) => switch (group) {
        SpellGroup.elixir => spellGroupElixir,
        SpellGroup.darkElixir => spellGroupDarkElixir,
        SpellGroup.other => spellGroupOther,
      };

  String buildingGroupLabel(BuildingGroup group) => switch (group) {
        BuildingGroup.main => buildingGroupMain,
        BuildingGroup.defense => buildingGroupDefense,
        BuildingGroup.resource => buildingGroupResource,
        BuildingGroup.army => buildingGroupArmy,
        BuildingGroup.traps => buildingGroupTraps,
        BuildingGroup.builderBase => buildingGroupBuilderBase,
      };

  String houseElementTypeLabel(String type) => switch (type) {
        'ground' => houseTypeGround,
        'roof' => houseTypeRoof,
        'walls' => houseTypeWalls,
        'decoration' || 'deco' => houseTypeDecoration,
        'foot' => houseTypeFoot,
        _ => houseTypeUnknown,
      };
}
