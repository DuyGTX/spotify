import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final cubit = context.read<SongPlayerCubit>();
        final position = cubit.songPosition;
        final duration = cubit.songDuration;
        final isPlaying = cubit.audioPlayer.playing;
        final bgColor = cubit.dominantColor ?? Colors.blue;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            title: Text(
              song.songName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,size: 15),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              ),
            ],
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
  }
}
