// lib/domain/usecases/favorite/is_favorite.dart
import 'package:dartz/dartz.dart';
import 'package:spotify/core/usecase/usecase.dart';
import 'package:spotify/domain/repository/favorite/favorite.dart';
import 'package:spotify/service_locator.dart';

class IsFavoriteUseCase implements Usecase<Either<String, bool>, int> {
  @override
  Future<Either<String, bool>> call({int? params}) async {
    return await sl<FavoriteSongRepository>().isFavorite(params!);
  }
}