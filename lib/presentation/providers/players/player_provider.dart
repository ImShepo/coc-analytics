import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/domain/entities/player.dart';
import 'package:coc/presentation/providers/players/players_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerProvider =
    StateNotifierProvider<PlayerNotifier, Map<String, AsyncValue<Player>>>((ref) {
  final playersRepository = ref.watch(playersRepositoryProvider);

  return PlayerNotifier(getPlayer: playersRepository.getPlayerById);
});

typedef GetPlayerCallback = Future<Player> Function(String playerId);

class PlayerNotifier extends StateNotifier<Map<String, AsyncValue<Player>>> {
  final GetPlayerCallback getPlayer;

  PlayerNotifier({
    required this.getPlayer,
  }) : super({});

  Future<void> loadPlayer(String playerId, {bool force = false}) async {
    final id = normalizePlayerTag(playerId);
    final current = state[id];
    if (current != null && current.isLoading) return;
    if (!force && current != null && current.hasValue) return;

    state = {...state, id: const AsyncValue.loading()};
    state = {
      ...state,
      id: await AsyncValue.guard(() => getPlayer(id)),
    };
  }
}
