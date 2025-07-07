// lib/data/repository/favorite/favorite_song_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/favorite/favorite_song_service.dart';

import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/favorite/favorite.dart';

import 'package:spotify/service_locator.dart';

class FavoriteSongRepositoryImpl implements FavoriteSongRepository {
  @override
  Future<Either<String, String>> addFavoriteSong(int songId) async {
    return await sl<FavoriteSongSupabaseService>().addFavoriteSong(songId);
  }

  @override
  Future<Either<String, String>> removeFavoriteSong(int songId) async {
    return await sl<FavoriteSongSupabaseService>().removeFavoriteSong(songId);
  }

  @override
  Future<Either<String, List<SongEntity>>> getFavoriteSongs() async {
    return await sl<FavoriteSongSupabaseService>().getFavoriteSongs();
  }

  @override
  Future<Either<String, bool>> isFavorite(int songId) async {
    return await sl<FavoriteSongSupabaseService>().isFavorite(songId);
  }
}