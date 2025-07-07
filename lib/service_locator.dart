import 'package:get_it/get_it.dart';
import 'package:spotify/data/repository/album/album_repository_impl.dart';

import 'package:spotify/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify/data/repository/favorite/favorite_repository_impl.dart';
import 'package:spotify/data/repository/song/song_repository_impl.dart';
import 'package:spotify/data/sources/album/album_supabase_service.dart';


import 'package:spotify/data/sources/auth/auth_supabase_service.dart';
import 'package:spotify/data/sources/favorite/favorite_song_service.dart';
import 'package:spotify/data/sources/songs/song_supabase_service.dart';

import 'package:spotify/domain/repository/album/album.dart';
import 'package:spotify/domain/repository/auth/auth.dart';
import 'package:spotify/domain/repository/favorite/favorite.dart';
import 'package:spotify/domain/repository/song/song.dart';


import 'package:spotify/domain/usecases/auth/signin.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';
import 'package:spotify/domain/usecases/favorite/add_favorite_song.dart';

import 'package:spotify/domain/usecases/favorite/get_favorite_songs.dart';
import 'package:spotify/domain/usecases/favorite/is_favorite.dart';
import 'package:spotify/domain/usecases/favorite/remove_favorite_song.dart';
import 'package:spotify/domain/usecases/song/get_outstrading_song.dart';
import 'package:spotify/domain/usecases/song/get_songs_by_album.dart';
import 'package:spotify/domain/usecases/song/get_trending.dart';
import 'package:spotify/domain/usecases/song/get_trending_album.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  /// Auth
  sl.registerLazySingleton<AuthSupabaseService>(() => AuthSupabaseServiceImpl());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<SignupUseCase>(() => SignupUseCase());
  sl.registerLazySingleton<SigninUseCase>(() => SigninUseCase());

  /// Song
  sl.registerLazySingleton<SongSupaBaseService>(() => SongSupaBaseServiceImpl());
  sl.registerLazySingleton<SongRepository>(() => SongRepositoryImpl());

  sl.registerLazySingleton<GetOutstradingSongUseCase>(
      () => GetOutstradingSongUseCase(sl()));
  sl.registerLazySingleton<GetTrendingSongUseCase>(
      () => GetTrendingSongUseCase(sl()));
  sl.registerLazySingleton<GetSongsByAlbumIdUseCase>(
      () => GetSongsByAlbumIdUseCase(sl()));

  /// Album
  sl.registerLazySingleton<AlbumSupabaseService>(() => AlbumSupabaseServiceImpl());
  sl.registerLazySingleton<AlbumRepository>(() => AlbumRepositoryImpl());

  sl.registerLazySingleton<GetTrendingAlbumsUseCase>(
      () => GetTrendingAlbumsUseCase(sl()));
  /// Favorite Song
  sl.registerLazySingleton<FavoriteSongSupabaseService>(() => FavoriteSongSupabaseServiceImpl());
  sl.registerLazySingleton<FavoriteSongRepository>(() => FavoriteSongRepositoryImpl());
  sl.registerLazySingleton<AddFavoriteSongUseCase>(() => AddFavoriteSongUseCase());
  sl.registerLazySingleton<RemoveFavoriteSongUseCase>(() => RemoveFavoriteSongUseCase());
  sl.registerLazySingleton<GetFavoriteSongsUseCase>(() => GetFavoriteSongsUseCase());
  sl.registerLazySingleton<IsFavoriteUseCase>(() => IsFavoriteUseCase());
}
