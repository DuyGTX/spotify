import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/common/helpers/is_dark_mode.dart';
import 'package:spotify/common/widgets/button/basic_app_button.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/presentation/choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget{
  const GetStartedPage ({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 45,
              horizontal: 45
            ),
            
          ),

          
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40,
              horizontal: 40
            ),
            child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset(
                    context.isDarkMode ? AppVectors.logo_dark : AppVectors.logo_light,
                     ),
                  ),
                  Spacer(),
                  Text(
                    'Trải nghiệm âm nhạc đỉnh cao',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25
                    ),
                  ),
                  SizedBox(height: 21,),
                  Text(
                    'Thưởng thức âm thanh chất lượng cao, tạo danh sách cá nhân và khám phá xu hướng mới nhất và hoàn toàn MIỄN PHÍ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                      fontSize: 17
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20,),
                  BasicAppButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(BuildContext context) => ChooseModePage()
                        )
                      );
                    }, 
                    title: 'Get Started'
                  )
                ],
              ),
          ),
        ],
      ),
    );
  }
}