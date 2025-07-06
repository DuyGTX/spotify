import 'package:bloc/bloc.dart';
import 'package:spotify/data/sources/search/search_history_service.dart';
import 'package:spotify/data/sources/search/search_service.dart';
import 'search_state.dart';



class SearchCubit extends Cubit<SearchState> {
  final SearchService searchService;
  final SearchHistoryService historyService;

  SearchCubit({
    required this.searchService,
    required this.historyService,
  }) : super(const SearchState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    final history = await historyService.get();
    final suggest = await searchService.suggestArtists();
    emit(state.copyWith(
      history: history,
      suggestArtists: suggest,
      viewState: SearchViewState.idle,
      searchText: '',
    ));
  }

  Future<void> onFocus() async {
    emit(state.copyWith(viewState: SearchViewState.focus));
  }

  void onBlur() {
    emit(state.copyWith(viewState: SearchViewState.idle, searchText: ''));
  }

  Future<void> search(String query) async {
  emit(state.copyWith(
    viewState: SearchViewState.searching,
    isLoading: true,
    searchText: query,
  ));
  try {
    final foundArtists = await searchService.searchArtists(query);
    List<Map<String, dynamic>> artistSongs = [];

    // Nếu có nghệ sĩ, lấy bài hát theo id nghệ sĩ đầu tiên
    if (foundArtists.isNotEmpty) {
      final artistId = foundArtists.first['id'];
      artistSongs = await searchService.getSongsByArtistId(artistId);
    }

    final foundSongs = await searchService.searchSongs(query);
    final foundAlbums = await searchService.searchAlbums(query);

    emit(state.copyWith(
      foundArtists: foundArtists,
      foundSongs: foundSongs,
      foundAlbums: foundAlbums,
      artistSongs: artistSongs, // << thêm trường này vào state!
      isLoading: false,
    ));
  } catch (e, s) {
    emit(state.copyWith(
      isLoading: false,
      foundArtists: [],
      foundSongs: [],
      foundAlbums: [],
      artistSongs: [],
    ));
  }
}





  Future<void> removeHistory(String keyword) async {
    await historyService.remove(keyword);
    final history = await historyService.get();
    emit(state.copyWith(history: history));
  }

  Future<void> clearHistory() async {
    await historyService.clear();
    emit(state.copyWith(history: []));
  }
}
