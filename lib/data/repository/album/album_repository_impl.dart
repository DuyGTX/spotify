import 'package:dartz/dartz.dart';
import 'package:spotify/data/sources/album/album_supabase_service.dart';

import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/repository/album/album.dart';

import 'package:spotify/service_locator.dart';

class AlbumRepositoryImpl extends AlbumRepository {
  final AlbumSupabaseService service = sl<AlbumSupabaseService>();

  @override
  Future<Either<Exception, List<AlbumEntity>>> getTrendingAlbums() {
    return service.getTrendingAlbums();
  }

  @override
  Future<Either<Exception, List<AlbumEntity>>> getAllAlbums() {
    return service.getAllAlbums();
  }
}
