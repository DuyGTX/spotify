import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/core/configs/assets/color_utils.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';


  
class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<int> _historyStack = []; // Lịch sử

  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;

  SongEntity? currentSong; // ✅ nullable
  late List<SongEntity> allSongs;
  int currentIndex = 0;
  bool isSongLoaded = false;
  Color? dominantColor;


  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      updateSongPlayer();
    });

    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        songDuration = duration;
      }
    });

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextSong();
      }
    });
  }

  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }

  
  Future<void> loadSong(
    String url,
    SongEntity song,
    List<SongEntity> all,
    int index, {
    bool isForward = true,
  }) async {
    if (isForward && currentSong != null && currentIndex != index) {
      _historyStack.add(currentIndex);
    }

    currentSong = song;
    allSongs = all;
    currentIndex = index;

    // Thêm đoạn này!
    dominantColor = await fetchDominantColor(song.coverImage);

    await audioPlayer.setUrl(url);
    await audioPlayer.play();
    isSongLoaded = true;
    emit(SongPlayerLoaded());
  }


  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }

  void playNextSong() {
    if (allSongs.isEmpty) return;

    final nextIndex = (currentIndex + 1) % allSongs.length;
    final nextSong = allSongs[nextIndex];

    loadSong(nextSong.songUrl, nextSong, allSongs, nextIndex, isForward: true);
  }

  void _playNextSong() {
    playNextSong();
  }

  void playPreviousSong() {
    if (_historyStack.isEmpty) return;

    final prevIndex = _historyStack.removeLast();
    final prevSong = allSongs[prevIndex];

    loadSong(prevSong.songUrl, prevSong, allSongs, prevIndex, isForward: false);
  }

  bool canGoBack() => _historyStack.isNotEmpty;

  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
