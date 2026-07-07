import 'package:coc/domain/entities/member_list.dart';
import 'package:coc/domain/entities/player_by_clan.dart' as domain;

class PlayerByClanMapper {
  static domain.PlayerByClan playerResponseToEntity(MemberList member) => domain.PlayerByClan(
        tag: member.tag,
        name: member.name,
        townHallLevel: member.townHallLevel,
        expLevel: member.expLevel,
        trophies: member.trophies,
        builderBaseTrophies: member.builderBaseTrophies,
        role: member.role,
        donations: member.donations,
        donationsReceived: member.donationsReceived,
      );
}
