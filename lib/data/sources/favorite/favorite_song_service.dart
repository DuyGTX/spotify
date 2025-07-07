// lib/data/sources/favorite/favorite_song_supabase_service.dart
import 'package:dartz/dartz.dart';


import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class FavoriteSongSupabaseService {
  Future<Either<String, String>> addFavoriteSong(int songId);
  Future<Either<String, String>> removeFavoriteSong(int songId);
  Future<Either<String, List<SongEntity>>> getFavoriteSongs();
  Future<Either<String, bool>> isFavorite(int songId);
}

class FavoriteSongSupabaseServiceImpl implements FavoriteSongSupabaseService {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<String, String>> addFavoriteSong(int songId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return const Left('User not authenticated');
      }

      // Check if already favorite
      final existingFavorite = await supabase
          .from('FavoriteSongs')
          .select('id')
          .eq('user_id', user.id)
          .eq('song_id', songId)
          .maybeSingle();

      if (existingFavorite != null) {
        return const Left('Song already in favorites');
      }

      await supabase.from('FavoriteSongs').insert({
        'user_id': user.id,
        'song_id': songId,
      });

      return const Right('Song added to favorites');
    } catch (e) {
      return Left('Failed to add song to favorites: $e');
    }
  }

  @override
  Future<Either<String, String>> removeFavoriteSong(int songId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return const Left('User not authenticated');
      }

      await supabase
          .from('FavoriteSongs')
          .delete()
          .eq('user_id', user.id)
          .eq('song_id', songId);

      return const Right('Song removed from favorites');
    } catch (e) {
      return Left('Failed to remove song from favorites: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getFavoriteSongs() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return const Left('User not authenticated');
      }

      final response = await supabase
          .from('FavoriteSongs')
          .select('''
            Songs (
              id,
              song_name,
              duration,
              release_date,
              genre,
              song_url,
              cover_image,
              album,
              trending,
              lyrics,
              lyrics_lrc,
              artist_id,
              Albums (
                album_name,
                album_cover
              ),
              Artists (
                id,
                name,
                avatar_image
              )
            )
          ''')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final songs = response.map((item) {
        final songData = item['Songs'];
        return SongModel.fromJson(songData).toEntity();
      }).toList();

      return Right(songs);
    } catch (e) {
      return Left('Failed to get favorite songs: $e');
    }
  }

  @override
  Future<Either<String, bool>> isFavorite(int songId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return const Right(false);
      }

      final response = await supabase
          .from('FavoriteSongs')
          .select('id')
          .eq('user_id', user.id)
          .eq('song_id', songId)
          .maybeSingle();

      return Right(response != null);
    } catch (e) {
      return Left('Failed to check favorite status: $e');
    }
  }
}