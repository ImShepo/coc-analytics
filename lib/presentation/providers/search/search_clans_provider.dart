import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coc/presentation/providers/providers.dart';
import 'package:coc/domain/entities/clan.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedClansProvider =
    StateNotifierProvider<SearchedClansNotifier, List<Clan>>((ref) {
  final clanRepository = ref.read(clanRepositoryProvider);

  return SearchedClansNotifier(
      searchClans: clanRepository.searchClans, ref: ref);
});

typedef SearchClansCallback = Future<List<Clan>> Function(String query);

class SearchedClansNotifier extends StateNotifier<List<Clan>> {
  final SearchClansCallback searchClans;
  final Ref ref;

  SearchedClansNotifier({
    required this.searchClans,
    required this.ref,
  }) : super([]);

  Future<List<Clan>> searchClansByQuery(String query) async {
    final List<Clan> clans = await searchClans(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = clans;
    return clans;
  }
}
