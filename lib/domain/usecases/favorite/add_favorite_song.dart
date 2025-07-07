// lib/domain/usecases/favorite/add_favorite_song.dart
import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/favorite/favorite.dart';
import 'package:spotify/service_locator.dart';

class AddFavoriteSongUseCase implements Usecase<Either<String, String>, int> {
  @override
  Future<Either<String, String>> call({int? params}) async {
    return await sl<FavoriteSongRepository>().addFavoriteSong(params!);
  }
}