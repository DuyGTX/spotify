import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/lyrics/lyrics_page.dart';
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
              if (!cubit.isSongLoaded || cubit.currentSong?.id != songEntity.id) {
                cubit.loadSong(songEntity.songUrl, songEntity, allSongs, currentIndex);
              }
            });

            return BlocBuilder<SongPlayerCubit, SongPlayerState>(
              builder: (context, state) {
                final cubit = context.read<SongPlayerCubit>();

                if (cubit.currentSong == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final song = cubit.currentSong!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _songCover(context, song),
                      const SizedBox(height: 20),
                      _songDetail(context, song),
                      const SizedBox(height: 20),
                      _songPlayer(context),
                      const SizedBox(height: 20),
                      _playControls(context),
                      const SizedBox(height: 20),
                      _lyricsSection(context, song),
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

  Widget _songDetail(BuildContext context, SongEntity song) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              song.songName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 5),
            Text(
              song.artist,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
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
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              iconSize: 32,
              onPressed: cubit.canGoBack()
                  ? () {
                      cubit.playPreviousSong();
                    }
                  : null,
            ),
            const SizedBox(width: 20),
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              child: IconButton(
                onPressed: cubit.playOrPauseSong,
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
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              iconSize: 32,
              onPressed: () {
                cubit.playNextSong();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _lyricsSection(BuildContext context, SongEntity song) {
  final cubit = context.read<SongPlayerCubit>();
  final bgColor = cubit.dominantColor ?? Colors.transparent;

  final lrc = song.lyricsLrc.trim();
  final previewLines = lrc.isNotEmpty
      ? lrc.split('\n').map((e) {
          final idx = e.indexOf(']');
          return idx != -1 ? e.substring(idx + 1).trim() : e.trim();
        }).where((e) => e.isNotEmpty).take(5).join('\n')
      : (song.lyrics.isNotEmpty ? song.lyrics.split('\n').take(5).join('\n') : 'Không có lời bài hát');

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bản xem trước lời bài hát",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          previewLines,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        if (lrc.isNotEmpty) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LyricsPage(
                      lyricsLrc: song.lyricsLrc,
                      song: song,
                    ),
                  ),
                );

              },
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ]
      ],
    ),
  );
}


  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
