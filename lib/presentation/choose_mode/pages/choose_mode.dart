import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/presentation/auth/pages/signup_or_siginin.dart';
import 'package:spotify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:spotify/presentation/choose_mode/pages/day_night_switch.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_vectors.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            // Logo luôn nằm trên đầu, không co kéo
            SvgPicture.asset(
              isDarkMode ? AppVectors.logo_dark : AppVectors.logo_light,
              
              fit: BoxFit.contain,
            ),
            // Cụm ở giữa màn hình
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Chọn giao diện',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  DayNightSwitch(
                    isDarkMode: isDarkMode,
                    onChanged: (value) {
                      context.read<ThemeCubit>().updateTheme(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Nút tiếp tục ở dưới cùng
             Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 48), // giống trang Đăng ký/Đăng nhập
                child: BasicAppButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SignupOrSighinPage()
                      ),
                    );
                  },
                  title: 'Tiếp tục',
                  height: 52,
                ),
              ),
             )
          ],
        ),
      ),
    );
  }
}
