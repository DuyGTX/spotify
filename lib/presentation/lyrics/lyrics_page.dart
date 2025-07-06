import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/core/configs/assets/color_utils.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/lyrics/lrc_helper.dart';
import 'package:spotify/presentation/lyrics/lrc_lyrics_view.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';

import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class LyricsPage extends StatelessWidget {
  final String lyricsLrc;
  final SongEntity song;

  const LyricsPage({
    super.key,
    required this.lyricsLrc,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    final lines = parseLrc(lyricsLrc);

    return FutureBuilder<Color?>(
      future: fetchDominantColor(song.coverImage), // Lấy dominantColor cho cover này
      builder: (context, snapshot) {
        final bgColor = snapshot.data ?? Colors.transparent;

        // Nếu bạn vẫn muốn sync player (seek, play/pause), bạn có thể bọc BlocBuilder bên trong:
        return BlocBuilder<SongPlayerCubit, SongPlayerState>(
          builder: (context, state) {
            final cubit = context.read<SongPlayerCubit>();
            final position = cubit.songPosition;
            final duration = cubit.songDuration;
            final isPlaying = cubit.audioPlayer.playing;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: bgColor,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  song.songName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 15),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: LrcLyricsView(
                lines: lines,
                position: position,
                duration: duration,
                isPlaying: isPlaying,
                backgroundColor: bgColor,
              ),
            );
          },
        );
      },
    );
  }
}
