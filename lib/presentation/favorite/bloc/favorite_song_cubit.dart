// lib/presentation/favorite/bloc/favorite_song_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/usecases/favorite/add_favorite_song.dart';


import 'package:spotify/domain/usecases/favorite/get_favorite_songs.dart';
import 'package:spotify/domain/usecases/favorite/is_favorite.dart';
import 'package:spotify/domain/usecases/favorite/remove_favorite_song.dart';

import 'package:spotify/presentation/favorite/bloc/favorite_song_state.dart';
import 'package:spotify/service_locator.dart';

class FavoriteSongCubit extends Cubit<FavoriteSongState> {
  FavoriteSongCubit() : super(FavoriteSongInitial());

  final Map<int, bool> _favoriteCache = {};

  Future<void> addFavoriteSong(int songId) async {
    emit(FavoriteSongLoading());
    
    final result = await sl<AddFavoriteSongUseCase>().call(params: songId);
    
    result.fold(
      (error) => emit(FavoriteSongError(error)),
      (message) {
        _favoriteCache[songId] = true;
        emit(FavoriteSongSuccess(message));
      },
    );
  }

  Future<void> removeFavoriteSong(int songId) async {
    emit(FavoriteSongLoading());
    
    final result = await sl<RemoveFavoriteSongUseCase>().call(params: songId);
    
    result.fold(
      (error) => emit(FavoriteSongError(error)),
      (message) {
        _favoriteCache[songId] = false;
        emit(FavoriteSongSuccess(message));
      },
    );
  }

  Future<void> getFavoriteSongs() async {
    emit(FavoriteSongLoading());
    
    final result = await sl<GetFavoriteSongsUseCase>().call();
    
    result.fold(
      (error) => emit(FavoriteSongError(error)),
      (songs) {
        // Update cache
        for (final song in songs) {
          _favoriteCache[song.id] = true;
        }
        emit(FavoriteSongListLoaded(songs));
      },
    );
  }

  Future<void> checkIsFavorite(int songId) async {
    // Check cache first
    if (_favoriteCache.containsKey(songId)) {
      emit(FavoriteSongStatusChecked(_favoriteCache[songId]!));
      return;
    }

    final result = await sl<IsFavoriteUseCase>().call(params: songId);
    
    result.fold(
      (error) => emit(FavoriteSongError(error)),
      (isFavorite) {
        _favoriteCache[songId] = isFavorite;
        emit(FavoriteSongStatusChecked(isFavorite));
      },
    );
  }

  Future<void> toggleFavorite(int songId) async {
    final isFavorite = _favoriteCache[songId] ?? false;
    
    if (isFavorite) {
      await removeFavoriteSong(songId);
    } else {
      await addFavoriteSong(songId);
    }
  }

  bool isFavoriteInCache(int songId) {
    return _favoriteCache[songId] ?? false;
  }
}