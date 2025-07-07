import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/presentation/choose_mode/pages/choose_mode.dart';
import 'package:spotify/presentation/dashboard/main_screen.dart';
// import thêm nếu muốn về SignupOrSigninPage

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppVectors.logo_loading),
      ),
    );
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      // Đã đăng nhập, vào thẳng MainScreen/HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      // Chưa đăng nhập, sang ChooseModePage (hoặc SignupOrSigninPage tuỳ ý bạn)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChooseModePage()),
      );
    }
  }
}
