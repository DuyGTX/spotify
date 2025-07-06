import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/core/configs/theme/app_theme.dart';
import 'package:spotify/presentation/auth/pages/signup.dart';
import 'package:spotify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify/presentation/dashboard/main_screen.dart';
import 'package:spotify/presentation/home/pages/home.dart';

import 'package:spotify/presentation/song_player/bloc/mini_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/pages/song_player.dart';
import 'package:spotify/presentation/splash/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotify/service_locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://weqbsgrtipzvyrfkaolv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndlcWJzZ3J0aXB6dnlyZmthb2x2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAzMjMwMzMsImV4cCI6MjA2NTg5OTAzM30.nY45CKXRg3vpUf1G6xQClXcFjDyyiuG-3JNic_Z42AM',
  );
  await initializeDependencies();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
    BlocProvider<SongPlayerCubit>(create: (_) => SongPlayerCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          debugShowCheckedModeBanner: false,
          home: const MainScreen(),
        ),
      ),
    );
  }
}