// lib/domain/repository/favorite/favorite_song.dart
import 'package:dartz/dartz.dart';

import 'package:spotify/domain/entities/song/song.dart';

abstract class FavoriteSongRepository {
  Future<Either<String, String>> addFavoriteSong(int songId);
  Future<Either<String, String>> removeFavoriteSong(int songId);
  Future<Either<String, List<SongEntity>>> getFavoriteSongs();
  Future<Either<String, bool>> isFavorite(int songId);
}