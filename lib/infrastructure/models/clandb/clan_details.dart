class ClanDetails {
  final String tag;
  final String name;
  final String type;
  final String description;
  final Location location;
  final bool isFamilyFriendly;
  final BadgeUrls badgeUrls;
  final int clanLevel;
  final int clanPoints;
  final int clanBuilderBasePoints;
  final int clanCapitalPoints;
  final League capitalLeague;
  final int requiredTrophies;
  final String warFrequency;
  final int warWinStreak;
  final int warWins;
  final int warTies;
  final int warLosses;
  final bool isWarLogPublic;
  final League warLeague;
  final int members;
  final List<MemberList> memberList;
  final List<Label> labels;
  final int requiredBuilderBaseTrophies;
  final int requiredTownhallLevel;
  final ClanCapital clanCapital;
  final ChatLanguage chatLanguage;

  ClanDetails({
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

  factory ClanDetails.fromJson(Map<String, dynamic> json) => ClanDetails(
        tag: json["tag"] ?? '',
        name: json["name"] ?? '',
        type: json["type"] ?? '',
        description: json["description"] ?? '',
        location: json["location"] != null
            ? Location.fromJson(json["location"] as Map<String, dynamic>)
            : Location(id: 0, name: '', isCountry: false, countryCode: ''),
        isFamilyFriendly: json["isFamilyFriendly"] ?? false,
        badgeUrls: json["badgeUrls"] != null
            ? BadgeUrls.fromJson(json["badgeUrls"] as Map<String, dynamic>)
            : BadgeUrls(small: '', large: '', medium: ''),
        clanLevel: json["clanLevel"] ?? 0,
        clanPoints: json["clanPoints"] ?? 0,
        clanBuilderBasePoints: json["clanBuilderBasePoints"] ?? 0,
        clanCapitalPoints: json["clanCapitalPoints"] ?? 0,
        capitalLeague: json["capitalLeague"] != null
            ? League.fromJson(json["capitalLeague"] as Map<String, dynamic>)
            : League(id: 0, name: ''),
        requiredTrophies: json["requiredTrophies"] ?? 0,
        warFrequency: json["warFrequency"] ?? '',
        warWinStreak: json["warWinStreak"] ?? 0,
        warWins: json["warWins"] ?? 0,
        warTies: json["warTies"] ?? 0,
        warLosses: json["warLosses"] ?? 0,
        isWarLogPublic: json["isWarLogPublic"] ?? false,
        warLeague: json["warLeague"] != null
            ? League.fromJson(json["warLeague"] as Map<String, dynamic>)
            : League(id: 0, name: ''),
        members: json["members"] ?? 0,
        memberList: (json["memberList"] as List<dynamic>?)
                ?.map((x) => MemberList.fromJson(x as Map<String, dynamic>))
                .toList() ??
            [],
        labels: (json["labels"] as List<dynamic>?)
                ?.map((x) => Label.fromJson(x as Map<String, dynamic>))
                .toList() ??
            [],
        requiredBuilderBaseTrophies: json["requiredBuilderBaseTrophies"] ?? 0,
        requiredTownhallLevel: json["requiredTownhallLevel"] ?? 0,
        clanCapital: json["clanCapital"] != null
            ? ClanCapital.fromJson(json["clanCapital"] as Map<String, dynamic>)
            : ClanCapital(),
        chatLanguage: json["chatLanguage"] != null
            ? ChatLanguage.fromJson(
                json["chatLanguage"] as Map<String, dynamic>)
            : ChatLanguage(id: 0, name: '', languageCode: ''),
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "type": type,
        "description": description,
        "location": location.toJson(),
        "isFamilyFriendly": isFamilyFriendly,
        "badgeUrls": badgeUrls.toJson(),
        "clanLevel": clanLevel,
        "clanPoints": clanPoints,
        "clanBuilderBasePoints": clanBuilderBasePoints,
        "clanCapitalPoints": clanCapitalPoints,
        "capitalLeague": capitalLeague.toJson(),
        "requiredTrophies": requiredTrophies,
        "warFrequency": warFrequency,
        "warWinStreak": warWinStreak,
        "warWins": warWins,
        "warTies": warTies,
        "warLosses": warLosses,
        "isWarLogPublic": isWarLogPublic,
        "warLeague": warLeague.toJson(),
        "members": members,
        "memberList": List<dynamic>.from(memberList.map((x) => x.toJson())),
        "labels": List<dynamic>.from(labels.map((x) => x.toJson())),
        "requiredBuilderBaseTrophies": requiredBuilderBaseTrophies,
        "requiredTownhallLevel": requiredTownhallLevel,
        "clanCapital": clanCapital.toJson(),
        "chatLanguage": chatLanguage.toJson(),
      };
}

class BadgeUrls {
  final String small;
  final String large;
  final String medium;

  BadgeUrls({
    required this.small,
    required this.large,
    required this.medium,
  });

  factory BadgeUrls.fromJson(Map<String, dynamic> json) => BadgeUrls(
        small: json["small"] ?? '',
        large: json["large"] ?? '',
        medium: json["medium"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "large": large,
        "medium": medium,
      };
}

class League {
  final int id;
  final String name;

  League({
    required this.id,
    required this.name,
  });

  factory League.fromJson(Map<String, dynamic> json) => League(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ChatLanguage {
  final int id;
  final String name;
  final String languageCode;

  ChatLanguage({
    required this.id,
    required this.name,
    required this.languageCode,
  });

  factory ChatLanguage.fromJson(Map<String, dynamic> json) => ChatLanguage(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        languageCode: json["languageCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "languageCode": languageCode,
      };
}

class ClanCapital {
  ClanCapital();

  factory ClanCapital.fromJson(Map<String, dynamic> json) => ClanCapital();

  Map<String, dynamic> toJson() => {};
}

class Label {
  final int id;
  final String name;
  final LabelIconUrls iconUrls;

  Label({
    required this.id,
    required this.name,
    required this.iconUrls,
  });

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        iconUrls: json["iconUrls"] != null
            ? LabelIconUrls.fromJson(json["iconUrls"] as Map<String, dynamic>)
            : LabelIconUrls(small: '', medium: ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUrls": iconUrls.toJson(),
      };
}

class LabelIconUrls {
  final String small;
  final String medium;

  LabelIconUrls({
    required this.small,
    required this.medium,
  });

  factory LabelIconUrls.fromJson(Map<String, dynamic> json) => LabelIconUrls(
        small: json["small"] ?? '',
        medium: json["medium"]  ?? '',
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "medium": medium,
      };
}

class Location {
  final int id;
  final String name;
  final bool isCountry;
  final String countryCode;

  Location({
    required this.id,
    required this.name,
    required this.isCountry,
    required this.countryCode,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        isCountry: json["isCountry"] ?? false,
        countryCode: json["countryCode"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isCountry": isCountry,
        "countryCode": countryCode,
      };
}

class MemberList {
  final String tag;
  final String name;
  final String role;
  final int townHallLevel;
  final int expLevel;
  final LeagueClass league;
  final int trophies;
  final int builderBaseTrophies;
  final int clanRank;
  final int previousClanRank;
  final int donations;
  final int donationsReceived;
  final League builderBaseLeague;

  MemberList({
    required this.tag,
    required this.name,
    required this.role,
    required this.townHallLevel,
    required this.expLevel,
    required this.league,
    required this.trophies,
    required this.builderBaseTrophies,
    required this.clanRank,
    required this.previousClanRank,
    required this.donations,
    required this.donationsReceived,
    required this.builderBaseLeague,
  });

  factory MemberList.fromJson(Map<String, dynamic> json) => MemberList(
        tag: json["tag"] ?? '',
        name: json["name"] ?? '',
        role: json["role"] ?? '',
        townHallLevel: json["townHallLevel"] ?? 0,
        expLevel: json["expLevel"] ?? 0,
        league: json["league"] != null
            ? LeagueClass.fromJson(json["league"] as Map<String, dynamic>)
            : LeagueClass(
                id: 0, name: '', iconUrls: LeagueIconUrls(small: '', tiny: '', medium: '')),
        trophies: json["trophies"] ?? 0,
        builderBaseTrophies: json["builderBaseTrophies"] ?? 0,
        clanRank: json["clanRank"] ?? 0,
        previousClanRank: json["previousClanRank"] ?? 0,
        donations: json["donations"] ?? 0,
        donationsReceived: json["donationsReceived"] ?? 0,
        builderBaseLeague: json["builderBaseLeague"] != null
            ? League.fromJson(json["builderBaseLeague"] as Map<String, dynamic>)
            : League(id: 0, name: ''),
      );

  Map<String, dynamic> toJson() => {
        "tag": tag,
        "name": name,
        "role": role,
        "townHallLevel": townHallLevel,
        "expLevel": expLevel,
        "league": league.toJson(),
        "trophies": trophies,
        "builderBaseTrophies": builderBaseTrophies,
        "clanRank": clanRank,
        "previousClanRank": previousClanRank,
        "donations": donations,
        "donationsReceived": donationsReceived,
        "builderBaseLeague": builderBaseLeague.toJson(),
      };
}

class LeagueClass {
  final int id;
  final String name;
  final LeagueIconUrls iconUrls;

  LeagueClass({
    required this.id,
    required this.name,
    required this.iconUrls,
  });

  factory LeagueClass.fromJson(Map<String, dynamic> json) => LeagueClass(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        iconUrls: json["iconUrls"] != null
            ? LeagueIconUrls.fromJson(json["iconUrls"] as Map<String, dynamic>)
            : LeagueIconUrls(small: '', tiny: '', medium: ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iconUrls": iconUrls.toJson(),
      };
}

class LeagueIconUrls {
  final String small;
  final String tiny;
  final String medium;

  LeagueIconUrls({
    required this.small,
    required this.tiny,
    required this.medium,
  });

  factory LeagueIconUrls.fromJson(Map<String, dynamic> json) => LeagueIconUrls(
        small: json["small"] ?? '',
        tiny: json["tiny"] ?? '',
        medium: json["medium"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "small": small,
        "tiny": tiny,
        "medium": medium,
      };
}
