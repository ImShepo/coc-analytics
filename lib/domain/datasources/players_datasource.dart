import 'package:coc/domain/entities/player.dart';
import 'package:coc/domain/entities/player_by_clan.dart';

abstract class PlayersDatasource {

  Future<Player> getPlayerById( String id );

  Future<List<PlayerByClan>> getPlayersByClan( String clanId );
}