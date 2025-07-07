// lib/domain/usecases/favorite/get_favorite_songs.dart
import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/domain/repository/favorite/favorite.dart';
import 'package:spotify/service_locator.dart';

class GetFavoriteSongsUseCase implements Usecase<Either<String, List<SongEntity>>, void> {
  @override
  Future<Either<String, List<SongEntity>>> call({void params}) async {
    return await sl<FavoriteSongRepository>().getFavoriteSongs();
  }
}