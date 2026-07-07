import 'badge_urls.dart';
import 'chat_language.dart';
import 'clan_capital.dart';
import 'label.dart';
import 'league.dart';
import 'location.dart';
import 'member_list.dart';

class Clan {
  String tag;
  String name;
  String type;
  String description;
  Location location;
  bool isFamilyFriendly;
  BadgeUrls badgeUrls;
  int clanLevel;
  int clanPoints;
  int clanBuilderBasePoints;
  int clanCapitalPoints;
  League capitalLeague;
  int requiredTrophies;
  String warFrequency;
  int warWinStreak;
  int warWins;
  int warTies;
  int warLosses;
  bool isWarLogPublic;
  League warLeague;
  int members;
  List<MemberList> memberList;
  List<Label> labels;
  int requiredBuilderBaseTrophies;
  int requiredTownhallLevel;
  ClanCapital clanCapital;
  ChatLanguage chatLanguage;

  Clan({
    required this.tag,
    required this.name,
    required this.type,
    required this.description,
    required this.location,
    required this.isFamilyFriendly,
    required this.badgeUrls,
    required this.clanLevel,
    required this.clanPoints,
    required this.clanBuilderBasePoints,
    required this.clanCapitalPoints,
    required this.capitalLeague,
    required this.requiredTrophies,
    required this.warFrequency,
    required this.warWinStreak,
    required this.warWins,
    required this.warTies,
    required this.warLosses,
    required this.isWarLogPublic,
    required this.warLeague,
    required this.members,
    required this.memberList,
    required this.labels,
    required this.requiredBuilderBaseTrophies,
    required this.requiredTownhallLevel,
    required this.clanCapital,
    required this.chatLanguage,
  });
}
