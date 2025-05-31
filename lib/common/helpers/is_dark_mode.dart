import 'package:flutter/material.dart';

extension DarkMode on BuildContext {

  bool get IsDarkMode {
    return Theme.of(this).brightness ==  Brightness.dark;
  }
}