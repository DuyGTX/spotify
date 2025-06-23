import 'package:get_it/get_it.dart';
import 'package:spotify/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify/data/repository/song/song_repository_impl.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/data/sources/songs/song_supabase_service.dart';
import 'package:spotify/domain/repository/auth/auth.dart';
import 'package:spotify/domain/repository/song/song.dart';
import 'package:spotify/domain/usecases/auth/signin.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';
import 'package:spotify/domain/usecases/song/get_outstrading_song.dart';
import 'package:spotify/domain/usecases/song/get_trending.dart'; // ✅ Import use case của bạn

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Firebase service
  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  // Auth repo
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // UseCases
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  // Song service
  sl.registerSingleton<SongSupaBaseService>(SongSupaBaseServiceImpl());

  // Song repository
  sl.registerSingleton<SongRepository>(
    SongRepositoryImpl(), // SỬA tại đây: không cần truyền sl() vì bên trong đã tự gọi sl
  );

  // Đăng ký GetOutstradingSongUseCase
  sl.registerSingleton<GetOutstradingSongUseCase>(
    GetOutstradingSongUseCase(sl<SongRepository>()),
  );

  // Đăng ký GetTrendingUseCase
  sl.registerSingleton<GetTrendingSongUseCase>(
    GetTrendingSongUseCase(sl<SongRepository>()),
  );

}
