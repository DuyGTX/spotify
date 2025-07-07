import 'package:flutter/material.dart';

class DayNightSwitch extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const DayNightSwitch({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isDarkMode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 160,
        height: 56,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isDarkMode ? Colors.white : Colors.black12,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 18,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Text: animated vị trí
            AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 350),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: isDarkMode
                      ? Text(
                          'NỀN\nTỐI',
                          key: ValueKey('night'),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        )
                      : Text(
                          'NỀN\nSÁNG',
                          key: ValueKey('day'),
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),
            ),
            // Icon: animated vị trí
            AnimatedAlign(
              duration: const Duration(milliseconds: 400),
              alignment:
                  isDarkMode ? Alignment.centerLeft : Alignment.centerRight,
              curve: Curves.easeInOutCubic,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.8)
                          : Colors.orangeAccent.withOpacity(0.7),
                      width: 2,
                    ),
                    boxShadow: [
                      if (isDarkMode)
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 12,
                        ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 350),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: isDarkMode
                          ? Icon(
                              Icons.nightlight_round,
                              key: ValueKey('moon'),
                              color: Colors.black,
                              size: 32,
                            )
                          : Icon(
                              Icons.wb_sunny,
                              key: ValueKey('sun'),
                              color: Colors.orangeAccent,
                              size: 32,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
