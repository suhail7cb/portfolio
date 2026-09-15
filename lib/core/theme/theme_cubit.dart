import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit managing theme mode (Dark by default, togglable to Light).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.dark);

  void toggleTheme() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  void setTheme(ThemeMode mode) {
    emit(mode);
  }

  bool get isDark => state == ThemeMode.dark;
}
