import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/lyrics/lrc_helper.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';

class LrcLyricsView extends StatefulWidget {
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
  State<LrcLyricsView> createState() => _LrcLyricsViewState();
}

class _LrcLyricsViewState extends State<LrcLyricsView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeAnimationController;
  late AnimationController _scaleAnimationController;
  int _currentIndex = 0;
  int _previousIndex = -1;
  bool _isScrolling = false;
  
  // Constants for better performance
  static const double _itemHeight = 45.0;
  static const double _centerOffset = 3.0;
  static const Duration _animationDuration = Duration(milliseconds: 400);
  static const Curve _animationCurve = Curves.easeOutCubic;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fadeAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    
    // Start animations
    _fadeAnimationController.forward();
    _scaleAnimationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeAnimationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LrcLyricsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final newIndex = _getCurrentIndex();
    if (newIndex != _currentIndex) {
      _previousIndex = _currentIndex;
      _currentIndex = newIndex;
      
      // Trigger smooth animations
      _fadeAnimationController.reset();
      _scaleAnimationController.reset();
      _fadeAnimationController.forward();
      _scaleAnimationController.forward();
      
      _scrollToCurrentLine();
    }
  }

  void _scrollToCurrentLine() {
    if (!_scrollController.hasClients || _isScrolling) return;
    
    _isScrolling = true;
    
    final targetOffset = (_currentIndex - _centerOffset)
        .clamp(0.0, (widget.lines.length - 1).toDouble()) * _itemHeight;
    
    _scrollController.animateTo(
      targetOffset,
      duration: _animationDuration,
      curve: _animationCurve,
    ).then((_) {
      _isScrolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Colors.black,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08, // Increased to 8% padding
            vertical: 16,
          ),
          child: Column(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _fadeAnimationController,
                    _scaleAnimationController,
                  ]),
                  builder: (context, child) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: widget.lines.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildLyricLine(index);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildProgressBar(context),
              const SizedBox(height: 12),
              _buildPlayPauseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLyricLine(int index) {
    final line = widget.lines[index];
    final isCurrent = index == _currentIndex;
    final isPrevious = index == _previousIndex;
    
    // Calculate opacity based on distance from current line
    double opacity;
    if (isCurrent) {
      opacity = 1.0;
    } else {
      final distance = (index - _currentIndex).abs();
      opacity = (1.0 - (distance * 0.15)).clamp(0.3, 0.7);
    }
    
    // Calculate scale with smooth animation - reduced scale to prevent overflow
    double scale = 1.0;
    if (isCurrent) {
      scale = 1.0 + (0.08 * _scaleAnimationController.value); // Reduced from 0.12 to 0.08
    } else if (isPrevious) {
      scale = 1.08 - (0.08 * _scaleAnimationController.value); // Reduced from 0.12 to 0.08
    }

    // Calculate dynamic height based on proximity to current line
    double dynamicHeight = _itemHeight;
    final distanceFromCurrent = (index - _currentIndex).abs();
    
    if (isCurrent) {
      // Current line gets much more height
      dynamicHeight = _itemHeight + (35 * _scaleAnimationController.value);
    } else if (distanceFromCurrent == 1) {
      // Adjacent lines get more height
      dynamicHeight = _itemHeight + (20 * _scaleAnimationController.value);
    } else if (distanceFromCurrent == 2) {
      // Second adjacent lines get medium extra height
      dynamicHeight = _itemHeight + (12 * _scaleAnimationController.value);
    }

    return AnimatedContainer(
      duration: _animationDuration,
      curve: _animationCurve,
      height: dynamicHeight,
      child: Center(
        child: AnimatedOpacity(
          duration: _animationDuration,
          curve: _animationCurve,
          opacity: opacity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Transform.scale(
                scale: scale,
                child: AnimatedDefaultTextStyle(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  style: TextStyle(
                    fontSize: isCurrent ? 17 : 17,
                    color: Colors.white,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    letterSpacing: isCurrent ? 0.3 : 0,
                    height: 1.4,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * 0.95, // Ensure text fits within 95% of available width
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4, // Further reduced horizontal padding
                      vertical: isCurrent ? 14 : 4,
                    ),
                    child: Text(
                      line.text.isEmpty ? "♪" : line.text,
                      textAlign: TextAlign.center,
                      maxLines: null, // Allow unlimited lines
                      overflow: TextOverflow.visible, // Show all text
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    const progressColor = Colors.white;
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: progressColor,
              inactiveTrackColor: progressColor.withOpacity(0.3),
              trackHeight: 3.0,
              thumbColor: progressColor,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayColor: progressColor.withOpacity(0.1),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            ),
            child: Slider(
              value: widget.position.inSeconds.toDouble().clamp(
                0.0, 
                widget.duration.inSeconds.toDouble()
              ),
              min: 0.0,
              max: widget.duration.inSeconds.toDouble(),
              onChanged: (value) {
                context.read<SongPlayerCubit>().audioPlayer.seek(
                  Duration(seconds: value.toInt()),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(widget.position),
                  style: const TextStyle(
                    fontSize: 12,
                    color: progressColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDuration(widget.duration),
                  style: const TextStyle(
                    fontSize: 12,
                    color: progressColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: IconButton(
        onPressed: () {
          context.read<SongPlayerCubit>().playOrPauseSong();
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            key: ValueKey<bool>(widget.isPlaying),
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  int _getCurrentIndex() {
    if (widget.lines.isEmpty) return 0;
    
    int idx = 0;
    for (int i = 0; i < widget.lines.length; i++) {
      if (widget.position >= widget.lines[i].time) {
        idx = i;
      } else {
        break;
      }
    }
    return idx;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}