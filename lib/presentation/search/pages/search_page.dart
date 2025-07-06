import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/data/sources/search/search_history_service.dart';
import 'package:spotify/data/sources/search/search_service.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        searchService: SearchService(),
        historyService: SearchHistoryService(),
      ),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late TextEditingController controller;
  String selectedFilter = 'Tất cả';

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: Column(
            children: [
              SizedBox(height: 30),
              // Search Bar with Cancel button
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: "Nghệ sĩ, bài hát, album và danh sách phát...",
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            size: 20,
                          ),
                          suffixIcon: state.searchText.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    controller.clear();
                                    context.read<SearchCubit>().onBlur();
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          isDense: true,
                        ),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                        onTap: () => context.read<SearchCubit>().onFocus(),
                        onSubmitted: (value) {
                          context.read<SearchCubit>().search(value);
                        },
                        onChanged: (value) {
                          // Real-time search if needed
                        },
                      ),
                    ),
                    if (state.viewState == SearchViewState.focus || state.viewState == SearchViewState.searching)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            controller.clear();
                            context.read<SearchCubit>().onBlur();
                          },
                          child: Text(
                            "Hủy",
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            
              // Filter buttons (only show when idle)
              if (state.viewState == SearchViewState.idle)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      _buildFilterButton('Tất cả', isSelected: selectedFilter == 'Tất cả', isDarkMode: isDarkMode),
                      SizedBox(width: 12),
                      _buildFilterButton('Thể loại', isSelected: selectedFilter == 'Thể loại', isDarkMode: isDarkMode),
                      SizedBox(width: 12),
                      _buildFilterButton('Tâm trạng', isSelected: selectedFilter == 'Tâm trạng', isDarkMode: isDarkMode),
                    ],
                  ),
                ),
              
              SizedBox(height: 16),
              
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButton(String text, {required bool isSelected, required bool isDarkMode}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : (isDarkMode ? Colors.white : Colors.black),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (state.viewState == SearchViewState.idle) {
      return _buildGenreMoodGrid(isDarkMode);
    }
    if (state.viewState == SearchViewState.focus && state.searchText.isEmpty) {
      return _buildHistoryAndSuggest(context, state, isDarkMode);
    }
    if (state.viewState == SearchViewState.searching) {
      return _buildSearchResult(state, isDarkMode);
    }
    return Container();
  }

  Widget _buildGenreMoodGrid(bool isDarkMode) {
    final genres = [
      {'name': 'Pop', 'color': Colors.green[700]},
      {'name': 'Tình yêu', 'color': Colors.pink[700]},
      {'name': 'Tiệc tùng', 'color': Colors.red[700]},
      {'name': 'Afrosounds', 'color': Colors.green[800]},
      {'name': 'Buồn', 'color': Colors.blue[900]},
      {'name': 'Mùa hè', 'color': Colors.orange[300]},
      {'name': 'Ca-ri-bê', 'color': Colors.blue[700]},
      {'name': 'Thể thao', 'color': Colors.brown[700]},
      {'name': 'Phai nhạt', 'color': Colors.purple[700]},
      {'name': 'Hip-Hop', 'color': Colors.blue[800]},
      {'name': 'Thư giãn', 'color': Colors.grey[700]},
      {'name': 'Cảm hứng', 'color': Colors.green[900]},
    ];

    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
        ),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Container(
            decoration: BoxDecoration(
              color: genre['color'] as Color? ?? Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Background pattern/image could be added here
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    genre['name'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Decorative elements in top right
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryAndSuggest(BuildContext context, SearchState state, bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: ListView(
        children: [
          if (state.history.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "TÌM KIẾM GẦN ĐÂY",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                ...state.history.map((h) => ListTile(
                      title: Text(h, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                      trailing: IconButton(
                        icon: Icon(Icons.close, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        onPressed: () => context.read<SearchCubit>().removeHistory(h),
                      ),
                      onTap: () {
                        context.read<SearchCubit>().search(h);
                        controller.text = h;
                      },
                    )),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "TÌM KIẾM ĐƯỢC ĐỀ XUẤT",
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          ...state.suggestArtists.map((a) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: a['avatar_image'] != null 
                      ? NetworkImage(a['avatar_image']) 
                      : null,
                  backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                ),
                title: Text(a['name'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                subtitle: Text('Nghệ sĩ', style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
                onTap: () {
                  context.read<SearchCubit>().search(a['name']);
                  controller.text = a['name'];
                },
              )),
        ],
      ),
    );
  }

  Widget _buildSearchResult(SearchState state, bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.black : Colors.white,
      child: state.isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.orange))
          : ListView(
              children: [
                // Artists section
                if (state.foundArtists.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Nghệ sĩ",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ...state.foundArtists.map((a) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: a['avatar_image'] != null 
                                  ? NetworkImage(a['avatar_image']) 
                                  : null,
                              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                            ),
                            title: Text(a['name'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                            subtitle: Text('Nghệ sĩ', style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
                          )),
                    ],
                  ),
                if (state.artistSongs.isNotEmpty)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Bài hát của nghệ sĩ",
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      ...state.artistSongs.map((s) => ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: s['cover_image'] != null
                  ? Image.network(
                      s['cover_image'],
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.music_note, color: isDarkMode ? Colors.white : Colors.black),
            ),
            title: Text(s['song_name'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            onTap: () {
              final song = SongEntity.fromMap(s);
              final allSongEntities = state.artistSongs.map((ss) => SongEntity.fromMap(ss)).toList();
              final index = allSongEntities.indexWhere((e) => e.id == song.id);

              context.read<SongPlayerCubit>().loadSong(
                song.songUrl,
                song,
                allSongEntities,
                index,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongPlayerPage(
                    songEntity: song,
                    allSongs: allSongEntities,
                    currentIndex: index,
                  ),
                ),
              );
            },
          )),
    ],
  ),
                // Songs section
                if (state.foundSongs.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Bài hát",
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ...state.foundSongs.map((s) => ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: s['cover_image'] != null
                                ? Image.network(
                                    s['cover_image'],
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.music_note, color: isDarkMode ? Colors.white : Colors.black),
                          ),
                          title: Text(
                            s['song_name'] ?? "",
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                            onTap: () {
    final song = SongEntity.fromMap(s);
    final allSongEntities = state.foundSongs.map((ss) => SongEntity.fromMap(ss)).toList();
    final index = allSongEntities.indexWhere((e) => e.id == song.id);

    // GỌI loadSong TẠI ĐÂY (trước khi mở SongPlayerPage)
    context.read<SongPlayerCubit>().loadSong(song.songUrl, song, allSongEntities, index);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SongPlayerPage(
          songEntity: song,
          allSongs: allSongEntities,
          currentIndex: index,
        ),
      ),
    );
  },
                          // Bạn có thể bổ sung subtitle, onTap, v.v. tại đây
                        )),
                  ],
                ),
                // Albums section
                if (state.foundAlbums.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Album",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ...state.foundAlbums.map((a) => ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: a['album_cover'] != null 
                                  ? Image.network(
                                      a['album_cover'],
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.album, color: isDarkMode ? Colors.white : Colors.black),
                            ),
                            title: Text(a['album_name'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                          )),
                    ],
                  ),
              ],
            ),
    );
  }
}