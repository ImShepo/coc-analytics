import 'package:coc/infrastructure/datasources/player_db_datasource.dart';
import 'package:coc/infrastructure/repositories/player_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playersRepositoryProvider = Provider((ref) {
  return PlayerRepositoryImpl( PlayerDBDatasource() );
});