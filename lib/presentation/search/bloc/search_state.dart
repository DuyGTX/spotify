import 'package:equatable/equatable.dart';

enum SearchViewState { idle, focus, searching }

class SearchState extends Equatable {
  final SearchViewState viewState;
  final String searchText;
  final List<String> history;
  final List<Map<String, dynamic>> suggestArtists;
  final List<Map<String, dynamic>> foundArtists;
  final List<Map<String, dynamic>> foundSongs;
  final List<Map<String, dynamic>> foundAlbums;
  final bool isLoading;
  final List<Map<String, dynamic>> artistSongs;

  const SearchState({
    this.viewState = SearchViewState.idle,
    this.searchText = '',
    this.history = const [],
    this.suggestArtists = const [],
    this.foundArtists = const [],
    this.foundSongs = const [],
    this.foundAlbums = const [],
    this.isLoading = false,
    this.artistSongs = const [],
    
  });

  SearchState copyWith({
    SearchViewState? viewState,
    String? searchText,
    List<String>? history,
    List<Map<String, dynamic>>? suggestArtists,
    List<Map<String, dynamic>>? foundArtists,
    List<Map<String, dynamic>>? foundSongs,
    List<Map<String, dynamic>>? foundAlbums,
    bool? isLoading,
    List<Map<String, dynamic>>? artistSongs,
  }) {
    return SearchState(
      viewState: viewState ?? this.viewState,
      searchText: searchText ?? this.searchText,
      history: history ?? this.history,
      suggestArtists: suggestArtists ?? this.suggestArtists,
      foundArtists: foundArtists ?? this.foundArtists,
      foundSongs: foundSongs ?? this.foundSongs,
      foundAlbums: foundAlbums ?? this.foundAlbums,
      isLoading: isLoading ?? this.isLoading,
      artistSongs: artistSongs ?? this.artistSongs,
    );
  }

  @override
  List<Object?> get props => [
        viewState,
        searchText,
        history,
        suggestArtists,
        foundArtists,
        foundSongs,
        foundAlbums,
        isLoading,
      ];
}
