import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/song/song.dart';

class GetSongsByAlbumIdUseCase implements Usecase<Either<Exception, List<SongEntity>>, int> {
  final SongRepository repository;

  GetSongsByAlbumIdUseCase(this.repository);

  @override
  Future<Either<Exception, List<SongEntity>>> call({int? params}) {
    return repository.getSongsByAlbumId(params!);
  }
}
