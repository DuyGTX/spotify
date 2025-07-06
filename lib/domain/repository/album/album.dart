import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/album/album.dart';

abstract class AlbumRepository {
  Future<Either<Exception, List<AlbumEntity>>> getTrendingAlbums();
  Future<Either<Exception, List<AlbumEntity>>> getAllAlbums();
}