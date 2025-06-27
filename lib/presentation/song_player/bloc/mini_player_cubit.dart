import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';

class MiniPlayerCubit extends Cubit<SongEntity?> {
  MiniPlayerCubit() : super(null);

  void show(SongEntity song) => emit(song);

  void hide() => emit(null);
}
