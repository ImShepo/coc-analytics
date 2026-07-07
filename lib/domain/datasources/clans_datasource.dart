import 'package:coc/domain/entities/clan.dart';

abstract class ClansDatasource {

  Future<Clan> getClanById( String id );

  Future<List<Clan>> searchClans( String query );
}