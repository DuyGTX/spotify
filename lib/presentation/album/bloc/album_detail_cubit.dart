import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spotify/domain/repository/song/song.dart';

import 'album_detail_state.dart';

class AlbumDetailCubit extends Cubit<AlbumDetailState> {
  final SongRepository repository;

  AlbumDetailCubit(this.repository) : super(AlbumDetailInitial());

  Future<void> fetchSongsByAlbum(int albumId) async {
    emit(AlbumDetailLoading());
    final result = await repository.getSongsByAlbumId(albumId);
    result.fold(
      (failure) => emit(AlbumDetailError(failure.toString())),
      (songs) => emit(AlbumDetailLoaded(songs)),
    );
  }
}
