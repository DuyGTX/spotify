import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/album/bloc/album_detail_cubit.dart';
import 'package:spotify/presentation/album/bloc/album_detail_state.dart';

import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/service_locator.dart';

class AlbumDetailPage extends StatelessWidget {
  final AlbumEntity album;

  const AlbumDetailPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumDetailCubit(sl())..fetchSongsByAlbum(album.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(album.albumName),
        ),
        body: BlocBuilder<AlbumDetailCubit, AlbumDetailState>(
          builder: (context, state) {
            if (state is AlbumDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AlbumDetailError) {
              return Center(child: Text(state.message));
            }

            if (state is AlbumDetailLoaded) {
              final List<SongEntity> songs = state.songs;

              if (songs.isEmpty) {
                return const Center(child: Text('Không có bài hát trong album này.'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: songs.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final song = songs[index];
                  return ListTile(
                    leading: Image.network(song.coverImage, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(song.songName),
                    subtitle: Text(song.artistName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongPlayerPage(
                            songEntity: song,
                            allSongs: songs,
                            currentIndex: index,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
