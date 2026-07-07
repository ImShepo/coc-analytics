import 'package:coc/config/helpers/building_catalog.dart';
import 'package:coc/config/helpers/troop_catalog.dart';
import 'package:coc/config/helpers/unit_static_repository.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/l10n/app_localizations.dart';
import 'package:coc/l10n/catalog_l10n.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/models/category_unit.dart';
import 'package:coc/presentation/widgets/categories/category_unit_card.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';

enum _CategoryTab { troops, buildings, heroes, spells }

class CategoriesList extends StatefulWidget {
  final Player player;

  const CategoriesList({super.key, required this.player});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList>
    with AutomaticKeepAliveClientMixin {
  _CategoryTab _selected = _CategoryTab.troops;
  final Set<String> _expandedSections = {};
  int? _cachedPlayerKey;
  Map<TroopGroup, List<CategoryUnit>>? _troopsGrouped;
  Map<SpellGroup, List<CategoryUnit>>? _spellsGrouped;
  Map<BuildingGroup, List<CategoryUnit>>? _buildingsGrouped;
  List<CategoryUnit>? _heroes;
  List<CategoryUnit>? _equipment;

  String _sectionKey(String sectionId) => '${_selected.name}:$sectionId';

  int _playerCacheKey(Player player) => Object.hash(
        player.tag,
        player.townHallLevel,
        player.builderHallLevel,
        player.troops.length,
        player.heroes.length,
        player.spells.length,
      );

  void _ensurePlayerCache() {
    final key = _playerCacheKey(widget.player);
    if (_cachedPlayerKey == key) return;

    _cachedPlayerKey = key;
    _troopsGrouped = CategoryUnit.troopsGrouped(widget.player);
    _spellsGrouped = CategoryUnit.spellsGrouped(widget.player);
    _buildingsGrouped = CategoryUnit.buildingsGrouped(widget.player);
    _heroes = CategoryUnit.heroesFrom(widget.player);
    _equipment = CategoryUnit.equipmentFrom(widget.player);
  }

  bool _isSectionExpanded(String sectionId) =>
      _expandedSections.contains(_sectionKey(sectionId));

  void _toggleSection(String sectionId) {
    setState(() {
      final key = _sectionKey(sectionId);
      if (_expandedSections.contains(key)) {
        _expandedSections.remove(key);
      } else {
        _expandedSections.add(key);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    UnitStaticRepository.instance.load().then((_) {
      if (mounted) {
        setState(() => _cachedPlayerKey = null);
      }
    });
  }

  int get _totalCount {
    _ensurePlayerCache();
    return switch (_selected) {
      _CategoryTab.troops =>
        _troopsGrouped!.values.fold<int>(0, (sum, list) => sum + list.length),
      _CategoryTab.buildings =>
        _buildingsGrouped!.values.fold<int>(0, (sum, list) => sum + list.length),
      _CategoryTab.heroes => _heroes!.length + _equipment!.length,
      _CategoryTab.spells =>
        _spellsGrouped!.values.fold<int>(0, (sum, list) => sum + list.length),
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _ensurePlayerCache();
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: [
                _tab(_CategoryTab.troops, l10n.categoryTroops, Icons.groups_rounded),
                _tab(_CategoryTab.buildings, l10n.categoryBuildings, Icons.account_balance_rounded),
                _tab(_CategoryTab.heroes, l10n.categoryHeroes, Icons.shield_rounded),
                _tab(_CategoryTab.spells, l10n.categorySpells, Icons.auto_fix_high_rounded),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SummaryStrip(count: _totalCount, tab: _selected, l10n: l10n),
          const SizedBox(height: 18),
          _CategoryBody(
            tab: _selected,
            player: widget.player,
            l10n: l10n,
            troopsGrouped: _troopsGrouped!,
            spellsGrouped: _spellsGrouped!,
            buildingsGrouped: _buildingsGrouped!,
            heroes: _heroes!,
            equipment: _equipment!,
            isSectionExpanded: _isSectionExpanded,
            onSectionToggle: _toggleSection,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.categoryCollapseHint,
            textAlign: TextAlign.center,
            style: AppFonts.scrimCaption(),
          ),
        ],
      ),
    );
  }

  Widget _tab(_CategoryTab tab, String label, IconData icon) {
    final isSelected = _selected == tab;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GlassChipButton(
        label: label,
        icon: icon,
        selected: isSelected,
        onPressed: () => setState(() => _selected = tab),
      ),
    );
  }
}

class _CategoryBody extends StatelessWidget {
  final _CategoryTab tab;
  final Player player;
  final AppLocalizations l10n;
  final Map<TroopGroup, List<CategoryUnit>> troopsGrouped;
  final Map<SpellGroup, List<CategoryUnit>> spellsGrouped;
  final Map<BuildingGroup, List<CategoryUnit>> buildingsGrouped;
  final List<CategoryUnit> heroes;
  final List<CategoryUnit> equipment;
  final bool Function(String sectionId) isSectionExpanded;
  final void Function(String sectionId) onSectionToggle;

  const _CategoryBody({
    required this.tab,
    required this.player,
    required this.l10n,
    required this.troopsGrouped,
    required this.spellsGrouped,
    required this.buildingsGrouped,
    required this.heroes,
    required this.equipment,
    required this.isSectionExpanded,
    required this.onSectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      _CategoryTab.troops => _GroupedUnitsView(
          player: player,
          grouped: troopsGrouped,
          order: TroopCatalog.troopDisplayOrder,
          labelFor: l10n.troopGroupLabel,
          colorFor: TroopCatalog.troopGroupColor,
          emptyMessage: l10n.noTroopsRegistered,
          isSectionExpanded: isSectionExpanded,
          onSectionToggle: onSectionToggle,
        ),
      _CategoryTab.spells => _GroupedUnitsView(
          player: player,
          grouped: spellsGrouped,
          order: TroopCatalog.spellDisplayOrder,
          labelFor: l10n.spellGroupLabel,
          colorFor: TroopCatalog.spellGroupColor,
          emptyMessage: l10n.noSpellsRegistered,
          isSectionExpanded: isSectionExpanded,
          onSectionToggle: onSectionToggle,
        ),
      _CategoryTab.buildings => _GroupedUnitsView(
          player: player,
          grouped: buildingsGrouped,
          order: BuildingCatalog.buildingDisplayOrder,
          labelFor: l10n.buildingGroupLabel,
          colorFor: BuildingCatalog.groupColor,
          emptyMessage: l10n.noBuildingsRegistered,
          isSectionExpanded: isSectionExpanded,
          onSectionToggle: onSectionToggle,
        ),
      _CategoryTab.heroes => _HeroesBody(
          player: player,
          l10n: l10n,
          heroes: heroes,
          equipment: equipment,
          isSectionExpanded: isSectionExpanded,
          onSectionToggle: onSectionToggle,
        ),
    };
  }
}

class _SectionGroup {
  final String id;
  final String title;
  final Color color;
  final int count;
  final List<CategoryUnit> units;

  const _SectionGroup({
    required this.id,
    required this.title,
    required this.color,
    required this.count,
    required this.units,
  });
}

class _CollapsibleSectionsView extends StatelessWidget {
  final List<_SectionGroup> sections;
  final Player player;
  final bool Function(String sectionId) isSectionExpanded;
  final void Function(String sectionId) onSectionToggle;

  const _CollapsibleSectionsView({
    required this.sections,
    required this.player,
    required this.isSectionExpanded,
    required this.onSectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          _CollapsibleSection(
            title: sections[i].title,
            color: sections[i].color,
            count: sections[i].count,
            expanded: isSectionExpanded(sections[i].id),
            onToggle: () => onSectionToggle(sections[i].id),
            child: _UnitsGrid(units: sections[i].units, player: player),
          ),
          if (i < sections.length - 1) const SizedBox(height: 18),
        ],
      ],
    );
  }
}

class _CollapsibleSection extends StatelessWidget {
  final String title;
  final Color color;
  final int count;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;

  const _CollapsibleSection({
    required this.title,
    required this.color,
    required this.count,
    required this.expanded,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: _SectionHeader(
                      title: title,
                      color: color,
                      count: count,
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimary.withValues(
                            alpha: 0.55,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: expanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    child,
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _GroupedUnitsView<T extends Enum> extends StatelessWidget {
  final Player player;
  final Map<T, List<CategoryUnit>> grouped;
  final List<T> order;
  final String Function(T) labelFor;
  final Color Function(T) colorFor;
  final String emptyMessage;
  final bool Function(String sectionId) isSectionExpanded;
  final void Function(String sectionId) onSectionToggle;

  const _GroupedUnitsView({
    required this.player,
    required this.grouped,
    required this.order,
    required this.labelFor,
    required this.colorFor,
    required this.emptyMessage,
    required this.isSectionExpanded,
    required this.onSectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    final groups = order
        .where((group) => grouped[group]?.isNotEmpty ?? false)
        .toList();

    if (groups.isEmpty) {
      return _EmptyCategory(message: emptyMessage);
    }

    final sections = [
      for (final group in groups)
        _SectionGroup(
          id: group.name,
          title: labelFor(group),
          color: colorFor(group),
          count: grouped[group]!.length,
          units: grouped[group]!,
        ),
    ];

    return _CollapsibleSectionsView(
      sections: sections,
      player: player,
      isSectionExpanded: isSectionExpanded,
      onSectionToggle: onSectionToggle,
    );
  }
}

class _HeroesBody extends StatelessWidget {
  final Player player;
  final AppLocalizations l10n;
  final List<CategoryUnit> heroes;
  final List<CategoryUnit> equipment;
  final bool Function(String sectionId) isSectionExpanded;
  final void Function(String sectionId) onSectionToggle;

  const _HeroesBody({
    required this.player,
    required this.l10n,
    required this.heroes,
    required this.equipment,
    required this.isSectionExpanded,
    required this.onSectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (heroes.isEmpty && equipment.isEmpty) {
      return _EmptyCategory(message: l10n.noHeroesOrEquipmentRegistered);
    }

    final sections = [
      if (heroes.isNotEmpty)
        _SectionGroup(
          id: 'heroes',
          title: l10n.categoryHeroes,
          color: const Color(0xFF1565C0),
          count: heroes.length,
          units: heroes,
        ),
      if (equipment.isNotEmpty)
        _SectionGroup(
          id: 'equipment',
          title: l10n.equipment,
          color: Theme.of(context).colorScheme.primary,
          count: equipment.length,
          units: equipment,
        ),
    ];

    return _CollapsibleSectionsView(
      sections: sections,
      player: player,
      isSectionExpanded: isSectionExpanded,
      onSectionToggle: onSectionToggle,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  final int? count;

  const _SectionHeader({
    required this.title,
    required this.color,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontFamily: AppFonts.primary,
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontFamily: AppFonts.primary,
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _UnitsGrid extends StatelessWidget {
  final List<CategoryUnit> units;
  final Player player;

  const _UnitsGrid({required this.units, required this.player});

  static const _crossAxisCount = 3;
  static const _spacing = 8.0;
  static const _aspectRatio = 0.72;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth - _spacing * (_crossAxisCount - 1)) /
                _crossAxisCount;
        final cellHeight = cellWidth / _aspectRatio;

        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (var i = 0; i < units.length; i++)
              SizedBox(
                key: ValueKey(units[i].heroTag),
                width: cellWidth,
                height: cellHeight,
                child: CategoryUnitCard(
                  unit: units[i],
                  player: player,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  final int count;
  final _CategoryTab tab;
  final AppLocalizations l10n;

  const _SummaryStrip({
    required this.count,
    required this.tab,
    required this.l10n,
  });

  String get _label => switch (tab) {
        _CategoryTab.troops => l10n.troopsInProfile,
        _CategoryTab.buildings => l10n.buildingsInVillage,
        _CategoryTab.heroes => l10n.heroesAndEquipment,
        _CategoryTab.spells => l10n.spellsInProfile,
      };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.onPrimary.withValues(alpha: 0.92),
            colorScheme.onPrimary.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: colorScheme.primary,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _label,
              style: const TextStyle(
                fontFamily: AppFonts.primary,
                color: Colors.white,
                fontSize: 11,
                shadows: AppFonts.onDarkSurfaceOutline,
              ),
            ),
          ),
          const Icon(Icons.touch_app_rounded, color: Colors.white54, size: 16),
        ],
      ),
    );
  }
}

class _EmptyCategory extends StatelessWidget {
  final String message;

  const _EmptyCategory({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppFonts.light,
          color: Colors.grey.shade600,
          fontSize: 11,
        ),
      ),
    );
  }
}
