import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/album/album.dart';

import 'package:spotify/domain/usecases/song/get_trending_album.dart';
import 'trending_album_state.dart';

class TrendingAlbumCubit extends Cubit<TrendingAlbumState> {
  final GetTrendingAlbumsUseCase getTrendingAlbums;

  TrendingAlbumCubit(this.getTrendingAlbums) : super(TrendingAlbumInitial());

  void fetchTrendingAlbums() async {
    emit(TrendingAlbumLoading());
    final result = await getTrendingAlbums();
    result.fold(
      (failure) => emit(TrendingAlbumError(failure.toString())),
      (albums) => emit(TrendingAlbumLoaded(albums)),
    );
  }
}
