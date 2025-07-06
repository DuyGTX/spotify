import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/song/song.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SongSupaBaseService {
  Future<Either<Exception, List<SongEntity>>> getOutstandingSongs();
  Future<Either<Exception, List<SongEntity>>> getTrendingSongs();
  Future<Either<Exception, List<SongEntity>>> getSongsByAlbumId(int albumId);
}

class SongSupaBaseServiceImpl extends SongSupaBaseService {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<Either<Exception, List<SongEntity>>> getOutstandingSongs() async {
    try {
      final response = await client
          .from('Songs')
          .select('''
            id, song_name, duration, release_date, genre, song_url, cover_image, album,
            lyrics, lyrics_lrc, artist_id, album_id, Artists(name)
          ''')
          .order('release_date', ascending: false)
          .limit(9);

      final List<dynamic> rawList = response;
      final songs = rawList
          .map((item) => SongModel.fromJson(item as Map<String, dynamic>).toEntity())
          .toList();

      return Right(songs);
    } catch (e) {
      return Left(Exception('Failed to fetch outstanding songs: $e'));
    }
  }

  @override
  Future<Either<Exception, List<SongEntity>>> getTrendingSongs() async {
    try {
      final response = await client
          .from('Songs')
          .select('''
            id, song_name, duration, release_date, genre, song_url, cover_image, album,
            lyrics, lyrics_lrc, artist_id, album_id, Artists(name)
          ''')
          .eq('trending', true)
          .order('release_date', ascending: false)
          .limit(16);

      final List<dynamic> rawList = response;
      final songs = rawList
          .map((item) => SongModel.fromJson(item as Map<String, dynamic>).toEntity())
          .toList();

      return Right(songs);
    } catch (e) {
      return Left(Exception('Failed to fetch trending songs: $e'));
    }
  }

  @override
  Future<Either<Exception, List<SongEntity>>> getSongsByAlbumId(int albumId) async {
    try {
      final response = await client
          .from('Songs')
          .select('''
            id, song_name, duration, release_date, genre, song_url, cover_image, album,
            lyrics, lyrics_lrc, artist_id, album_id, Artists(name)
          ''')
          .eq('album_id', albumId);

      final List<dynamic> rawList = response;
      final songs = rawList
          .map((item) => SongModel.fromJson(item as Map<String, dynamic>).toEntity())
          .toList();

      return Right(songs);
    } catch (e) {
      return Left(Exception('Failed to fetch songs for albumId $albumId: $e'));
    }
  }
}
