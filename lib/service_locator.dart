import 'package:get_it/get_it.dart';
import 'package:spotify/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify/domain/repository/auth.dart';
import 'package:spotify/domain/usecases/auth/signin.dart';
import 'package:spotify/domain/usecases/auth/signup.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Firebase Service
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(),
  );

  // Repository
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );

  // Use Case
  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(),
  );

   sl.registerSingleton<SigninUseCase>(
    SigninUseCase(),
  );
}
