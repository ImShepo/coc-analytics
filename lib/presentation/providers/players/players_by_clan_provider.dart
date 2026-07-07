import 'package:coc/domain/entities/player_by_clan.dart';
import 'package:coc/presentation/providers/players/players_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playersByClanProvider = StateNotifierProvider<PlayersByClanNotifier, Map<String, List<PlayerByClan>>>((ref) {
  final playersRepository = ref.watch( playersRepositoryProvider );
  
  return PlayersByClanNotifier( getPlayers: playersRepository.getPlayersByClan );
});

typedef GetPlayersCallback = Future<List<PlayerByClan>>Function(String clanId);

class PlayersByClanNotifier extends StateNotifier<Map<String,List<PlayerByClan>>> {

  final GetPlayersCallback getPlayers;

  PlayersByClanNotifier({
    required this.getPlayers,
  }): super({});

  Future<void> loadPlayers( String clanId ) async {
    if ( state[clanId] != null ) return;

    final List<PlayerByClan> players = await getPlayers( clanId );
    state = { ...state, clanId: players };
  }
}