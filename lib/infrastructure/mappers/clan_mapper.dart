import 'package:coc/domain/entities/clan.dart';
import 'package:coc/domain/entities/badge_urls.dart';
import 'package:coc/domain/entities/chat_language.dart';
import 'package:coc/domain/entities/clan_capital.dart';
import 'package:coc/domain/entities/icon_urls.dart';
import 'package:coc/domain/entities/label.dart';
import 'package:coc/domain/entities/league.dart';
import 'package:coc/domain/entities/league_class.dart';
import 'package:coc/domain/entities/league_icon_urls.dart';
import 'package:coc/domain/entities/location.dart';
import 'package:coc/domain/entities/member_list.dart';
import 'package:coc/infrastructure/models/clandb/clan_db_response.dart' as api;
import 'package:coc/infrastructure/models/clandb/clan_details.dart'
    as api_details;

class ClanMapper {
  static Clan clanDBToEntity(api.Item item) => Clan(
        tag: item.tag,
        name: item.name,
        type: item.type,
        description: item.description,
        location: locationToEntity(item.location),
        isFamilyFriendly: item.isFamilyFriendly,
        badgeUrls: badgeUrlsToEntity(item.badgeUrls),
        clanLevel: item.clanLevel,
        clanPoints: item.clanPoints,
        clanBuilderBasePoints: item.clanBuilderBasePoints,
        clanCapitalPoints: item.clanCapitalPoints,
        capitalLeague: leagueToEntity(item.capitalLeague),
        requiredTrophies: item.requiredTrophies,
        warFrequency: item.warFrequency,
        warWinStreak: item.warWinStreak,
        warWins: item.warWins,
        warTies: item.warTies,
        warLosses: item.warLosses,
        isWarLogPublic: item.isWarLogPublic,
        warLeague: leagueToEntity(item.warLeague),
        members: item.members,
        labels: item.labels.map((apiLabel) => labelToEntity(apiLabel)).toList(),
        requiredBuilderBaseTrophies: item.requiredBuilderBaseTrophies,
        requiredTownhallLevel: item.requiredTownhallLevel,
        chatLanguage: chatLanguageToEntity(item.chatLanguage),
        memberList: item.memberList
            .map((apiLabel) => memberListToEntity(apiLabel))
            .toList(),
        clanCapital: clanCapitalToEntity(item.clanCapital),
      );

  static BadgeUrls badgeUrlsToEntity(api.BadgeUrls apiBadgeUrls) => BadgeUrls(
        small: apiBadgeUrls.small,
        large: apiBadgeUrls.large,
        medium: apiBadgeUrls.medium,
      );

  static League leagueToEntity(api.League apiLeague) => League(
        id: apiLeague.id,
        name: apiLeague.name,
      );

  static ClanCapital clanCapitalToEntity(api.ClanCapital apiCapital) =>
      ClanCapital(
        capitalHallLevel: apiCapital.capitalHallLevel,
        districts: apiCapital.districts
            .map(
              (d) => ClanCapitalDistrict(
                id: d.id,
                name: d.name,
                districtHallLevel: d.districtHallLevel,
              ),
            )
            .toList(),
      );

  static ChatLanguage chatLanguageToEntity(api.ChatLanguage apiChatLanguage) =>
      ChatLanguage(
        id: apiChatLanguage.id,
        name: apiChatLanguage.name,
        languageCode: apiChatLanguage.languageCode,
      );

  static Label labelToEntity(api.Label apiLabel) => Label(
        id: apiLabel.id,
        name: apiLabel.name,
        iconUrls: iconUrlsToEntity(apiLabel.iconUrls),
      );

  static IconUrls iconUrlsToEntity(api.IconUrls apiIconUrls) => IconUrls(
        small: apiIconUrls.small,
        medium: apiIconUrls.medium,
      );

  static Location locationToEntity(api.Location apiLocation) => Location(
        id: apiLocation.id,
        name: apiLocation.name,
        isCountry: apiLocation.isCountry,
        countryCode: apiLocation.countryCode,
      );

  static MemberList memberListToEntity(api.MemberList apiMemberList) =>
      MemberList(
        tag: apiMemberList.tag,
        name: apiMemberList.name,
        role: apiMemberList.role,
        townHallLevel: apiMemberList.townHallLevel,
        expLevel: apiMemberList.expLevel,
        league: leagueClassToEntity(apiMemberList.league),
        trophies: apiMemberList.trophies,
        builderBaseTrophies: apiMemberList.builderBaseTrophies,
        clanRank: apiMemberList.clanRank,
        previousClanRank: apiMemberList.previousClanRank,
        donations: apiMemberList.donations,
        donationsReceived: apiMemberList.donationsReceived,
        builderBaseLeague: leagueToEntity(apiMemberList.builderBaseLeague),
      );

  static LeagueClass leagueClassToEntity(api.LeagueClass apiLeagueClass) =>
      LeagueClass(
        id: apiLeagueClass.id,
        name: apiLeagueClass.name,
        iconUrls: leagueIconUrlsToEntity(apiLeagueClass.iconUrls),
      );

  static LeagueIconUrls leagueIconUrlsToEntity(
          api.LeagueIconUrls apiLeagueIconUrls) =>
      LeagueIconUrls(
        small: apiLeagueIconUrls.small,
        tiny: apiLeagueIconUrls.tiny,
        medium: apiLeagueIconUrls.medium,
      );

  static Clan clanDetailsToEntity(api_details.ClanDetails details) => Clan(
        tag: details.tag,
        name: details.name,
        type: details.type,
        description: details.description,
        location: locationDetailsToEntity(details.location),
        isFamilyFriendly: details.isFamilyFriendly,
        badgeUrls: badgeUrlsDetailsToEntity(details.badgeUrls),
        clanLevel: details.clanLevel,
        clanPoints: details.clanPoints,
        clanBuilderBasePoints: details.clanBuilderBasePoints,
        clanCapitalPoints: details.clanCapitalPoints,
        capitalLeague: leagueDetailsToEntity(details.capitalLeague),
        requiredTrophies: details.requiredTrophies,
        warFrequency: details.warFrequency,
        warWinStreak: details.warWinStreak,
        warWins: details.warWins,
        warTies: details.warTies,
        warLosses: details.warLosses,
        isWarLogPublic: details.isWarLogPublic,
        warLeague: leagueDetailsToEntity(details.warLeague),
        members: details.members,
        memberList: details.memberList
            .map((apiLabel) => memberListDetailsToEntity(apiLabel))
            .toList(),
        labels: details.labels
            .map((apiLabel) => labelDetailsToEntity(apiLabel))
            .toList(),
        requiredBuilderBaseTrophies: details.requiredBuilderBaseTrophies,
        requiredTownhallLevel: details.requiredTownhallLevel,
        clanCapital: clanCapitalDetailsToEntity(details.clanCapital),
        chatLanguage: chatLanguageDetailsToEntity(details.chatLanguage),
      );

  static Location locationDetailsToEntity(api_details.Location apiLocation) =>
      Location(
        id: apiLocation.id,
        name: apiLocation.name,
        isCountry: apiLocation.isCountry,
        countryCode: apiLocation.countryCode,
      );

  static BadgeUrls badgeUrlsDetailsToEntity(
          api_details.BadgeUrls apiBadgeUrls) =>
      BadgeUrls(
        small: apiBadgeUrls.small,
        large: apiBadgeUrls.large,
        medium: apiBadgeUrls.medium,
      );

  static ChatLanguage chatLanguageDetailsToEntity(
          api_details.ChatLanguage detailsChatLanguage) =>
      ChatLanguage(
        id: detailsChatLanguage.id,
        name: detailsChatLanguage.name,
        languageCode: detailsChatLanguage.languageCode,
      );

  static Label labelDetailsToEntity(api_details.Label detailsLabel) => Label(
        id: detailsLabel.id,
        name: detailsLabel.name,
        iconUrls: iconUrlsDetailsToEntity(detailsLabel.iconUrls),
      );

  static IconUrls iconUrlsDetailsToEntity(
          api_details.LabelIconUrls detailsIconUrls) =>
      IconUrls(
        small: detailsIconUrls.small,
        medium: detailsIconUrls.medium,
      );

  static League leagueDetailsToEntity(api_details.League apiLeague) => League(
        id: apiLeague.id,
        name: apiLeague.name,
      );

  static MemberList memberListDetailsToEntity(
          api_details.MemberList apiMemberList) =>
      MemberList(
        tag: apiMemberList.tag,
        name: apiMemberList.name,
        role: apiMemberList.role,
        townHallLevel: apiMemberList.townHallLevel,
        expLevel: apiMemberList.expLevel,
        league: leagueClassDetailsToEntity(apiMemberList.league),
        trophies: apiMemberList.trophies,
        builderBaseTrophies: apiMemberList.builderBaseTrophies,
        clanRank: apiMemberList.clanRank,
        previousClanRank: apiMemberList.previousClanRank,
        donations: apiMemberList.donations,
        donationsReceived: apiMemberList.donationsReceived,
        builderBaseLeague:
            leagueDetailsToEntity(apiMemberList.builderBaseLeague),
      );

  static LeagueClass leagueClassDetailsToEntity(
          api_details.LeagueClass apiLeagueClass) =>
      LeagueClass(
        id: apiLeagueClass.id,
        name: apiLeagueClass.name,
        iconUrls: leagueIconUrlsDetailsToEntity(apiLeagueClass.iconUrls),
      );

  static LeagueIconUrls leagueIconUrlsDetailsToEntity(
          api_details.LeagueIconUrls apiLeagueIconUrls) =>
      LeagueIconUrls(
        small: apiLeagueIconUrls.small,
        tiny: apiLeagueIconUrls.tiny,
        medium: apiLeagueIconUrls.medium,
      );

  static ClanCapital clanCapitalDetailsToEntity(
          api_details.ClanCapital clanCapital) =>
      ClanCapital(
        capitalHallLevel: clanCapital.capitalHallLevel,
        districts: clanCapital.districts
            .map(
              (d) => ClanCapitalDistrict(
                id: d.id,
                name: d.name,
                districtHallLevel: d.districtHallLevel,
              ),
            )
            .toList(),
      );
}
