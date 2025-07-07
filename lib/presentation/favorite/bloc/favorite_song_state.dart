// lib/presentation/favorite/bloc/favorite_song_state.dart
import 'package:spotify/domain/entities/song/song.dart';

abstract class FavoriteSongState {}

class FavoriteSongInitial extends FavoriteSongState {}

class FavoriteSongLoading extends FavoriteSongState {}

class FavoriteSongSuccess extends FavoriteSongState {
  final String message;
  
  FavoriteSongSuccess(this.message);
}

class FavoriteSongError extends FavoriteSongState {
  final String error;
  
  FavoriteSongError(this.error);
}

class FavoriteSongListLoaded extends FavoriteSongState {
  final List<SongEntity> songs;
  
  FavoriteSongListLoaded(this.songs);
}

class FavoriteSongStatusChecked extends FavoriteSongState {
  final bool isFavorite;
  
  FavoriteSongStatusChecked(this.isFavorite);
}