import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/album/album.dart';
import 'package:spotify/domain/repository/album/album.dart';


class GetTrendingAlbumsUseCase
    implements Usecase<Either<Exception, List<AlbumEntity>>, void> {
  final AlbumRepository repository;

  GetTrendingAlbumsUseCase(this.repository);

  @override
  Future<Either<Exception, List<AlbumEntity>>> call({void params}) {
    return repository.getTrendingAlbums();
  }
}
