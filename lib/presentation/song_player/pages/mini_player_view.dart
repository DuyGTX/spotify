import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';

class MiniPlayerView extends StatefulWidget {
  const MiniPlayerView({super.key});

  @override
  State<MiniPlayerView> createState() => _MiniPlayerViewState();
}

class _MiniPlayerViewState extends State<MiniPlayerView> {
  Color? _dominantColor;
  String? _currentSongId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePaletteIfNeeded();
  }

  void _updatePaletteIfNeeded() async {
    final cubit = context.read<SongPlayerCubit>();
    final song = cubit.currentSong;

    if (song == null) return;

    // Nếu chưa tải màu cho bài này
    if (_currentSongId == song.id.toString()) return;

    try {
      final palette = await PaletteGenerator.fromImageProvider(
        NetworkImage(song.coverImage),
        size: const Size(110, 110),
        maximumColorCount: 20,
      );

      setState(() {
        _dominantColor = palette.dominantColor?.color ?? Colors.black12;
        _currentSongId = song.id.toString();

        // NEW: cập nhật vào Cubit
        final cubit = context.read<SongPlayerCubit>();
        cubit.dominantColor = _dominantColor;
      });
    } catch (_) {
      setState(() {
        _dominantColor = Colors.black12;
        _currentSongId = song.id.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
      builder: (context, state) {
        final cubit = context.read<SongPlayerCubit>();

        if (cubit.currentSong == null ||
            cubit.audioPlayer.playerState.processingState == ProcessingState.idle) {
          return const SizedBox.shrink();
        }

        final song = cubit.currentSong!;

        _updatePaletteIfNeeded();

        return Dismissible(
          key: const Key('mini_player'),
          direction: DismissDirection.down,
          onDismissed: (direction) {
            cubit.audioPlayer.stop();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 0.0),
              elevation: 0,
              color: _dominantColor ?? Colors.black12,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 80, maxHeight: 90),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.transparent,
                        trackHeight: 2,
                        thumbColor: Colors.white,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                        overlayColor: Colors.transparent,
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 1.0),
                      ),
                      child: Slider(
                        value: cubit.songPosition.inSeconds
                            .clamp(0, cubit.songDuration.inSeconds)
                            .toDouble(),
                        max: cubit.songDuration.inSeconds.toDouble(),
                        onChanged: (value) {
                          cubit.audioPlayer
                              .seek(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                    ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SongPlayerPage(
                              songEntity: song,
                              allSongs: cubit.allSongs,
                              currentIndex: cubit.currentIndex,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        song.songName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        song.artistName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFC0C0C0),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          song.coverImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            "assets/img/cover.jpg",
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Image.asset(
                              "assets/img/cover.jpg",
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            );
                          },
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous_rounded,
                                color: Colors.white),
                            onPressed: cubit.canGoBack()
                                ? () {
                                    cubit.playPreviousSong();
                                  }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                              cubit.audioPlayer.playing
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            onPressed: cubit.playOrPauseSong,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next_rounded,
                                color: Colors.white),
                            onPressed: () {
                              cubit.playNextSong();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
