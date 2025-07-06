import 'package:dartz/dartz.dart';
import 'package:spotify/data/models/album/album.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/domain/entities/album/album.dart';

abstract class AlbumSupabaseService {
  Future<Either<Exception, List<AlbumEntity>>> getTrendingAlbums();
  Future<Either<Exception, List<AlbumEntity>>> getAllAlbums();
}

class AlbumSupabaseServiceImpl extends AlbumSupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  @override
  Future<Either<Exception, List<AlbumEntity>>> getTrendingAlbums() async {
    try {
      final response = await client
          .from('Albums')
          .select('''
            id, album_name, album_cover, release_date, artist_id, trending
          ''')
          .eq('trending', true)
          .order('id', ascending: false);

      final albums = (response as List<dynamic>)
          .map((item) => AlbumModel.fromJson(item).toEntity())
          .toList();

      return Right(albums);
    } catch (e, stack) {
      print("Lỗi lấy album thịnh hành: $e");
      return Left(Exception("Không thể tải album thịnh hành: $e"));
    }
  }

  @override
  Future<Either<Exception, List<AlbumEntity>>> getAllAlbums() async {
    try {
      final response = await client
          .from('Albums')
          .select('''
            id, album_name, album_cover, release_date, artist_id, Artists(name)
          ''')
          .order('release_date', ascending: false);

      final albums = (response as List<dynamic>)
          .map((item) => AlbumModel.fromJson(item).toEntity())
          .toList();

      return Right(albums);
    } catch (e) {
      return Left(Exception("Không thể tải danh sách album: $e"));
    }
  }
}
