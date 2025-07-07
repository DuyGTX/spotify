import 'package:flutter/material.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';

class BasicAppButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool isOutlined; // <-- Thêm thuộc tính này
  final Color? textColor;

  const BasicAppButton({
    required this.onPressed,
    required this.title,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    this.isOutlined = false, // <-- Mặc định là false
    this.textColor, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        height: height ?? 52,
        child: isOutlined
            ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side:  BorderSide(color: textColor ?? Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: onPressed,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                child: Text(
                  title,
                  style:  TextStyle(
                    color: textColor ?? Colors.white,// Text màu đen trên nền xanh
                    
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
      ),
    );
  }
}
