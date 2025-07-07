// lib/presentation/favorite/pages/favorite_songs_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/favorite/bloc/favorite_song_cubit.dart';
import 'package:spotify/presentation/favorite/bloc/favorite_song_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class FavoriteSongsPage extends StatefulWidget {
  const FavoriteSongsPage({super.key});

  @override
  State<FavoriteSongsPage> createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteSongCubit>().getFavoriteSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Bài hát đã thích',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        action: IconButton(
          onPressed: () {
            context.read<FavoriteSongCubit>().getFavoriteSongs();
          },
          icon: const Icon(Icons.refresh),
        ),
      ),
      body: BlocBuilder<FavoriteSongCubit, FavoriteSongState>(
        builder: (context, state) {
          if (state is FavoriteSongLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is FavoriteSongError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Có lỗi xảy ra: ${state.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoriteSongCubit>().getFavoriteSongs();
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          
          if (state is FavoriteSongListLoaded) {
            if (state.songs.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: AppColors.darkGrey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Chưa có bài hát yêu thích',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Hãy thêm bài hát vào danh sách yêu thích',
                      style: TextStyle(fontSize: 14, color: AppColors.darkGrey),
                    ),
                  ],
                ),
              );
            }
            
            return _buildSongList(state.songs);
          }
          
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSongList(List<SongEntity> songs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with play button
          Row(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bài hát đã thích',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${songs.length} bài hát',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Play all button
          Row(
            children: [
              FloatingActionButton(
                onPressed: () {
                  if (songs.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SongPlayerPage(
                          songEntity: songs.first,
                          allSongs: songs,
                          currentIndex: 0,
                        ),
                      ),
                    );
                  }
                },
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.play_arrow, color: Colors.white),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shuffle, size: 28),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Song list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return _buildSongTile(song, songs, index);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 4),
          )

        ],
      ),
    );
  }

  Widget _buildSongTile(SongEntity song, List<SongEntity> allSongs, int index) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(song.coverImage),
            fit: BoxFit.cover,
            
          ),
        ),
        
      ),
      
      title: Text(
        song.songName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artistName,
        style: const TextStyle(
          color: AppColors.darkGrey,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              context.read<FavoriteSongCubit>().removeFavoriteSong(song.id);
            },
            icon: const Icon(
              Icons.favorite,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.darkGrey,
            ),
          ),
        ],
        
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongPlayerPage(
              songEntity: song,
              allSongs: allSongs,
              currentIndex: index,
            ),
          ),
        );
      },
    );
    
  }
}