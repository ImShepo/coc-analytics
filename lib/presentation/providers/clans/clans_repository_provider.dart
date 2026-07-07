import 'package:coc/infrastructure/datasources/clan_db_datasource.dart';
import 'package:coc/infrastructure/repositories/clan_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clanRepositoryProvider = Provider((ref) {
  return ClanRepositoryImpl( ClanDBDatasource() );
});