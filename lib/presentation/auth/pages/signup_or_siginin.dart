import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';

import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/auth/pages/signin.dart';
import 'package:spotify/presentation/auth/pages/signup.dart';

import '../../../common/widgets/appbar/app_bar.dart';

class SignupOrSighinPage extends StatelessWidget {
  const SignupOrSighinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
           BasicAppbar(),
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              AppVectors.topPattern,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SvgPicture.asset(
              AppVectors.bottomPattern,
            ),
          ),
          // PHẦN TRUNG TÂM
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Để column không chiếm hết chiều cao
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    context.isDarkMode ? AppVectors.logo_dark : AppVectors.logo_light,
                  ),
                  const SizedBox(height: 20),
                   Text(
                    'Khám phá thế giới âm nhạc',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20,color: context.isDarkMode ? Colors.white : Colors.black,),
                    

                  ),
                  const SizedBox(height: 16),
                  
                ],
              ),
            ),
          ),
          // PHẦN BUTTON DƯỚI CÙNG
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 48), // padding dưới
              child: Row(
                children: [
                  Expanded(
                    child: BasicAppButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SignupPage(),
                          ),
                        );
                      },
                      title: 'Đăng ký',
                      height: 52,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: BasicAppButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SigninPage(),
                          ),
                        );
                      },
                      title: 'Đăng nhập',
                      height: 52,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
}