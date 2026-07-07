import 'package:coc/domain/entities/clan.dart';

abstract class ClansRepository {

  Future<Clan> getClanById( String id );

  Future<List<Clan>> searchClans( String query );
}