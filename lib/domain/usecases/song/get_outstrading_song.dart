// lib/domain/usecases/song/get_outstrading_song.dart

import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/song/song.dart';

class GetOutstradingSongUseCase
    implements Usecase<Either<Exception, List<SongEntity>>, void> {
  final SongRepository repository;

  GetOutstradingSongUseCase(this.repository);

  @override
  Future<Either<Exception, List<SongEntity>>> call({void params}) {
    return repository.getOutstandingSongs();
  }
}
