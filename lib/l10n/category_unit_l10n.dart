import 'package:coc/config/helpers/coc_unit_image.dart';
import 'package:coc/config/helpers/unit_static_repository.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/catalog_l10n.dart';
import 'package:coc/presentation/models/category_unit.dart';

extension CategoryUnitL10n on CategoryUnit {
  String categoryLabel(AppLocalizations l10n) => switch (category) {
        UnitCategory.troop => l10n.unitCategoryTroop,
        UnitCategory.hero => l10n.unitCategoryHero,
        UnitCategory.spell => l10n.unitCategorySpell,
        UnitCategory.equipment => l10n.unitCategoryEquipment,
        UnitCategory.building => l10n.unitCategoryBuilding,
      };

  String villageLabelL10n(AppLocalizations l10n) {
    if (village == 'home') return l10n.compareGroupTownHall;
    if (village == 'builderBase') return l10n.compareGroupBuilder;
    return village;
  }

  String villageShortLabelL10n(AppLocalizations l10n) {
    if (village == 'home') return l10n.villageHomeShort;
    if (village == 'builderBase') return l10n.compareGroupBuilder;
    return village;
  }

  String levelLabelForL10n(Player player, AppLocalizations l10n) {
    if (hasExactLevel) {
      return isUnlocked ? l10n.levelLabel(level) : l10n.locked;
    }

    if (isUnlocked && category == UnitCategory.building) {
      final staticItem = UnitStaticRepository.instance.findFor(this);
      if (staticItem != null) {
        final hall = village == 'builderBase'
            ? player.builderHallLevel
            : player.townHallLevel;
        final maxAtHall =
            UnitStaticRepository.instance.maxLevelAtTownHall(staticItem, hall);
        return l10n.upToLevel(maxAtHall);
      }
    }

    return isUnlocked
        ? l10n.available
        : l10n.requiresTownHallShort(unlockTownHall ?? 1);
  }

  String? resourceLabelL10n(AppLocalizations l10n) {
    if (troopGroup != null) return l10n.troopGroupLabel(troopGroup!);
    if (spellGroup != null) return l10n.spellGroupLabel(spellGroup!);
    return null;
  }
}

extension MemberRoleL10n on AppLocalizations {
  String memberRoleLabel(String role) => switch (role) {
        'leader' => roleLeader,
        'coLeader' => roleCoLeader,
        'admin' => roleElder,
        _ => roleMember,
      };
}
