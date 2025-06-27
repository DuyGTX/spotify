import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<int> _historyStack = []; // Lưu index của các bài đã nghe trước đó

  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  late SongEntity currentSong;
  late List<SongEntity> allSongs;
  int currentIndex = 0;
  bool canGoBack() => _historyStack.isNotEmpty;


  List<SongEntity> _allSongs = [];
  int _currentIndex = 0;
  void Function(SongEntity nextSong, int nextIndex)? onNext;

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

    // 💡 Tự động chuyển bài khi kết thúc
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNextSong();
      }
    });
  }

  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }

  Future<void> loadSong(String url, SongEntity song, List<SongEntity> all, int index, {bool isForward = true}) async {
  try {
    if (isForward && _allSongs.isNotEmpty && currentIndex != index) {
      _historyStack.add(currentIndex); // chỉ thêm nếu khác bài hiện tại
    }


    currentSong = song;
    allSongs = all;
    currentIndex = index;
    _allSongs = all;
    _currentIndex = index;

    await audioPlayer.setUrl(url);
    await audioPlayer.play();
    emit(SongPlayerLoaded());
  } catch (e) {
    print('Lỗi phát bài hát: $e');
  }
}




  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    emit(SongPlayerLoaded());
  }

  /// 🔁 Phát bài kế tiếp nếu còn
  void _playNextSong() {
    if (_allSongs.isEmpty) return;
    final nextIndex = (_currentIndex + 1) % _allSongs.length;
    final nextSong = _allSongs[nextIndex];
    _historyStack.add(_currentIndex); // Lưu trước khi chuyển bài
    onNext?.call(nextSong, nextIndex);
  }

  void playPreviousSong() {
  if (_historyStack.isEmpty) return; // Không có bài nào trước đó

  final prevIndex = _historyStack.removeLast();
  final prevSong = _allSongs[prevIndex];

  onNext?.call(prevSong, prevIndex); // Gọi lại trình phát bài với bài trước đó
}


  @override
  Future<void> close() {
    audioPlayer.dispose();
    return super.close();
  }
}
