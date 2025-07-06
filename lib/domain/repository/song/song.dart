import 'package:dartz/dartz.dart';
import 'package:spotify/domain/entities/song/song.dart';

abstract class SongRepository {
  Future<Either<Exception, List<SongEntity>>> getOutstandingSongs();
  Future<Either<Exception, List<SongEntity>>> getTrendingSongs();
  Future<Either<Exception, List<SongEntity>>> getSongsByAlbumId(int albumId);
}
