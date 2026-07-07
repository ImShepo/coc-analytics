import 'league.dart';
import 'league_class.dart';

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
}
