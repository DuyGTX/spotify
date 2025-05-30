

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode>{
  
  ThemeCubit() : super(ThemeMode.system);

  void updateTheme(ThemeMode themeMode) => emit(themeMode);
  @override
  fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
  
}