import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/lyrics/lrc_helper.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';

class LrcLyricsView extends StatelessWidget {
  final List<LyricLine> lines;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final Color? backgroundColor;

  const LrcLyricsView({
    super.key,
    required this.lines,
    required this.position,
    required this.duration,
    required this.isPlaying,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();

    return Container(
      color: backgroundColor ?? Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Lyrics List
          Expanded(
            child: ListView.builder(
              itemCount: lines.length,
              itemBuilder: (context, index) {
                final line = lines[index];
                final isCurrent = index == currentIndex;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Center(
                    child: Text(
                      line.text.isEmpty ? "(…)" : line.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isCurrent ? 20 : 16,
                        color: isCurrent ? Colors.white : const Color(0xFFC0C0C0),
                        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Process Bar (đầy đủ với text thời gian)
          _processBar(context),

          const SizedBox(height: 12),

          // Play/Pause
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            child: IconButton(
              onPressed: () {
                context.read<SongPlayerCubit>().playOrPauseSong();
              },
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
        ],
      ),
    );
  }

  Widget _processBar(BuildContext context) {
    const progressColor = Colors.white;

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
              context.read<SongPlayerCubit>().audioPlayer.seek(
                    Duration(seconds: value.toInt()),
                  );
            },
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatDuration(position), style: const TextStyle(fontSize: 12, color: progressColor)),
            Text(formatDuration(duration), style: const TextStyle(fontSize: 12, color: progressColor)),
          ],
        ),
      ],
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  int _getCurrentIndex() {
    int idx = 0;

    for (int i = 0; i < lines.length; i++) {
      if (position >= lines[i].time) {
        idx = i;
      } else {
        break;
      }
    }

    return idx;
  }
}
