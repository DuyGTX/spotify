import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  final List<SongEntity> allSongs;
  final int currentIndex;
  

  const SongPlayerPage({
    required this.songEntity,
    required this.allSongs,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Đang phát bài hát',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        action: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
      body: BlocProvider.value(
        value: context.read<SongPlayerCubit>(),
        child: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final cubit = context.read<SongPlayerCubit>();
              cubit.onNext = (nextSong, nextIndex) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SongPlayerPage(
                      songEntity: nextSong,
                      allSongs: allSongs,
                      currentIndex: nextIndex,
                    ),
                  ),
                );
              };
              cubit.loadSong(songEntity.songUrl, songEntity, allSongs, currentIndex);
            });

            return BlocBuilder<SongPlayerCubit, SongPlayerState>(
              builder: (context, state) {
                if (state is SongPlayerLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SongPlayerFailure) {
                  return const Center(child: Text("Không thể phát bài hát"));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    children: [
                      _songCover(context, songEntity),
                      const SizedBox(height: 20),
                      _songDetail(context),
                      const SizedBox(height: 20),
                      _songPlayer(context),
                      _playControls(context),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _songCover(BuildContext context, SongEntity song) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(song.coverImage),
        ),
      ),
    );
  }

  Widget _songDetail(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(songEntity.songName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 5),
            Text(songEntity.artist, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_outline_outlined, size: 30, color: AppColors.darkGrey),
        )
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final cubit = context.read<SongPlayerCubit>();
        final duration = cubit.songDuration;
        final position = cubit.songPosition;

        const progressColor = Color(0xFF434343);

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: progressColor,
                inactiveTrackColor: progressColor.withOpacity(0.3),
                trackHeight: 4.0,
                thumbColor: progressColor,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayColor: progressColor.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Slider(
                value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds.toDouble()),
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  cubit.audioPlayer.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDuration(position), style: const TextStyle(fontSize: 12, color: progressColor)),
                Text(formatDuration(duration), style: const TextStyle(fontSize: 12, color: progressColor)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _playControls(BuildContext context) {
  return BlocBuilder<SongPlayerCubit, SongPlayerState>(
    builder: (context, state) {
      final cubit = context.read<SongPlayerCubit>();
      final isPlaying = cubit.audioPlayer.playing;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ⏮ Previous
          IconButton(
            icon: const Icon(Icons.skip_previous_rounded),
            iconSize: 32,
            onPressed: cubit.canGoBack()
                ? () {
                    cubit.onNext = (prevSong, prevIndex) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SongPlayerPage(
                            songEntity: prevSong,
                            allSongs: cubit.allSongs,
                            currentIndex: prevIndex,
                          ),
                        ),
                      );
                    };
                    cubit.playPreviousSong();
                  }
                : null, // Nếu không có bài để quay lại, disable nút
          ),

          const SizedBox(width: 20),

          // ▶️ ⏸ Play/Pause
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: IconButton(
              onPressed: () => cubit.playOrPauseSong(),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  key: ValueKey<bool>(isPlaying),
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // ⏭ Next
          IconButton(
            icon: const Icon(Icons.skip_next_rounded),
            iconSize: 32,
            onPressed: () {
              final otherIndexes = List.generate(cubit.allSongs.length, (i) => i)..remove(cubit.currentIndex);
              otherIndexes.shuffle();
              final nextIndex = otherIndexes.first;
              final nextSong = cubit.allSongs[nextIndex];

              cubit.onNext = (next, index) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SongPlayerPage(
                      songEntity: next,
                      allSongs: cubit.allSongs,
                      currentIndex: index,
                    ),
                  ),
                );
              };

              Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => SongPlayerPage(
      songEntity: nextSong,
      allSongs: cubit.allSongs,
      currentIndex: nextIndex,
    ),
  ),
);


            },
          ),
        ],
      );
    },
  );
}


  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '')}:${seconds.toString().padLeft(2, '0')}';
  }
}
