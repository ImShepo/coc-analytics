import 'package:coc/domain/entities/player.dart' as domain;
import 'package:coc/infrastructure/models/playersdb/player_db_response.dart';

class PlayerMapper {
  static domain.Player playerResponseToEntity(PlayerResponse cast) => domain.Player(
        tag: cast.tag,
        name: cast.name,
        townHallLevel: cast.townHallLevel,
        townHallWeaponLevel: cast.townHallWeaponLevel,
        expLevel: cast.expLevel,
        trophies: cast.trophies,
        bestTrophies: cast.bestTrophies,
        warStars: cast.warStars,
        attackWins: cast.attackWins,
        defenseWins: cast.defenseWins,
        builderHallLevel: cast.builderHallLevel,
        builderBaseTrophies: cast.builderBaseTrophies,
        bestBuilderBaseTrophies: cast.bestBuilderBaseTrophies,
        role: cast.role,
        warPreference: cast.warPreference,
        donations: cast.donations,
        donationsReceived: cast.donationsReceived,
        clanCapitalContributions: cast.clanCapitalContributions,
        clan: PlayerMapper.clanToEntity(cast.clan),
        league: PlayerMapper.leagueToEntity(cast.league),
        builderBaseLeague:
            PlayerMapper.builderBaseLeagueToEntity(cast.builderBaseLeague),
        legendStatistics:
            PlayerMapper.legendStatisticsToEntity(cast.legendStatistics),
        achievements:
            cast.achievements.map(PlayerMapper.achievementToEntity).toList(),
        playerHouse: PlayerMapper.playerHouseToEntity(cast.playerHouse),
        labels: cast.labels.map(PlayerMapper.labelToEntity).toList(),
        troops: cast.troops.map(PlayerMapper.heroEquipmentToEntity).toList(),
        heroes: cast.heroes.map(PlayerMapper.heroEquipmentToEntity).toList(),
        heroEquipment:
            cast.heroEquipment.map(PlayerMapper.heroEquipmentToEntity).toList(),
        spells: cast.spells.map(PlayerMapper.heroEquipmentToEntity).toList(),
      );

  static domain.Clan clanToEntity(Clan cast) => domain.Clan(
        tag: cast.tag,
        name: cast.name,
        clanLevel: cast.clanLevel,
        badgeUrls: PlayerMapper.badgeUrlsToEntity(cast.badgeUrls),
      );

  static domain.BadgeUrls badgeUrlsToEntity(BadgeUrls cast) => domain.BadgeUrls(
        small: cast.small,
        large: cast.large,
        medium: cast.medium,
      );

  static domain.Achievement achievementToEntity(Achievement cast) =>
      domain.Achievement(
        name: cast.name,
        stars: cast.stars,
        value: cast.value,
        target: cast.target,
        info: cast.info,
        completionInfo: cast.completionInfo,
        village: cast.village,
      );

  static domain.BuilderBaseLeague builderBaseLeagueToEntity(
          BuilderBaseLeague cast) =>
      domain.BuilderBaseLeague(
        id: cast.id,
        name: cast.name,
      );

  static domain.League leagueToEntity(League cast) => domain.League(
        id: cast.id,
        name: cast.name,
        iconUrls: PlayerMapper.leagueIconUrlsToEntity(cast.iconUrls),
      );

  static domain.LeagueIconUrls leagueIconUrlsToEntity(LeagueIconUrls cast) =>
      domain.LeagueIconUrls(
        small: cast.small,
        tiny: cast.tiny,
        medium: cast.medium,
      );

  static domain.LegendStatistics legendStatisticsToEntity(
          LegendStatistics cast) =>
      domain.LegendStatistics(
        legendTrophies: cast.legendTrophies,
        previousSeason: PlayerMapper.seasonToEntity(cast.previousSeason),
        bestSeason: PlayerMapper.seasonToEntity(cast.bestSeason),
        currentSeason: PlayerMapper.currentSeasonToEntity(cast.currentSeason),
      );

  static domain.Season seasonToEntity(Season cast) => domain.Season(
        id: cast.id,
        rank: cast.rank,
        trophies: cast.trophies,
      );

  static domain.CurrentSeason currentSeasonToEntity(CurrentSeason cast) =>
      domain.CurrentSeason(
        rank: cast.rank,
        trophies: cast.trophies,
      );
  static domain.PlayerHouse playerHouseToEntity(PlayerHouse cast) =>
      domain.PlayerHouse(
        elements: cast.elements.map(PlayerMapper.elementToEntity).toList(),
      );

  static domain.Element elementToEntity(Element cast) => domain.Element(
        type: cast.type,
        id: cast.id,
      );

  static domain.Label labelToEntity(Label cast) => domain.Label(
        id: cast.id,
        name: cast.name,
        iconUrls: PlayerMapper.labelIconUrlsToEntity(cast.iconUrls),
      );

  static domain.LabelIconUrls labelIconUrlsToEntity(LabelIconUrls cast) =>
      domain.LabelIconUrls(
        small: cast.small,
        medium: cast.medium,
      );

  static domain.HeroEquipment heroEquipmentToEntity(HeroEquipment cast) =>
      domain.HeroEquipment(
        name: cast.name,
        level: cast.level,
        maxLevel: cast.maxLevel,
        village: cast.village,
        equipment: cast.equipment?.map(heroEquipmentToEntity).toList(),
      );
}
