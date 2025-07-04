import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant AppBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentIndex != oldWidget.currentIndex) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Stack(
    children: [
      // Navbar nội dung
      Container(
        height: 74,
        color: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: widget.currentIndex,
            onTap: widget.onTap,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: const Color(0xFF808080),
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: [
              _buildNavItem(0, "Trang chủ", "home_bottom", "home_bottom_off"),
              _buildNavItem(1, "Tìm kiếm", "search", "search_off"),
              _buildNavItem(2, "Thư viện", "music_library", "music_library_off"),
              _buildNavItem(3, "Hồ sơ", "profile", "profile_off"),
            ],
          ),
        ),
      ),

      
    ],
  );
}


  BottomNavigationBarItem _buildNavItem(
    int index,
    String label,
    String selectedIconAsset,
    String unselectedIconAsset,
  ) {
    Widget iconWidget;

    if (widget.currentIndex == index) {
      iconWidget = ScaleTransition(
        scale: _animation,
        child: SvgPicture.asset(
          "assets/vectors/$selectedIconAsset.svg",
          width: 24,
          height: 24,
        ),
      );
    } else {
      iconWidget = SvgPicture.asset(
        "assets/vectors/$unselectedIconAsset.svg",
        width: 24,
        height: 24,
      );
    }

    return BottomNavigationBarItem(
      icon: iconWidget,
      label: label,
    );
  }
}
