import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/usecases/song/get_trending.dart';
import 'package:spotify/presentation/home/bloc/trending_song_cubit.dart';
import 'package:spotify/presentation/home/bloc/trending_song_state.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/service_locator.dart';

class TrendingSong extends StatelessWidget {
  const TrendingSong({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrendingSongCubit(sl<GetTrendingSongUseCase>())..getTrendingSongs(),
      child: BlocBuilder<TrendingSongCubit, TrendingSongState>(
        builder: (context, state) {
          if (state is TrendingSongLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TrendingSongLoaded) {
            return _buildPagedGrid(context, state.songs);
          }
          return const Center(child: Text('Không có dữ liệu.'));
        },
      ),
    );
  }

  Widget _buildPagedGrid(BuildContext context, List<SongEntity> songs) {
    final pages = <List<SongEntity>>[];

    for (int i = 0; i < songs.length; i += 4) {
      pages.add(songs.skip(i).take(4).toList());
    }

    return SizedBox(
      height: 340,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: pages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, pageIndex) {
          final page = pages[pageIndex];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(page.length, (songIndex) {
              final globalIndex = pageIndex * 4 + songIndex;
              final song = songs[globalIndex];

              return GestureDetector(
                onTap: () {
                  // final cubit = context.read<SongPlayerCubit>();
                  // cubit.loadSong(song.songUrl, song, songs, index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SongPlayerPage(
                        songEntity: song,
                        allSongs: songs,
                        currentIndex: globalIndex,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          song.coverImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.songName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.artistName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
