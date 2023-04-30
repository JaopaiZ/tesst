import 'package:flutter/material.dart';

enum AppTheme {
  light,
  dark,
}

class ThemeProvider with ChangeNotifier {
  AppTheme _selectedTheme = AppTheme.light;

  AppTheme get selectedTheme => _selectedTheme;

  set selectedTheme(AppTheme theme) {
    _selectedTheme = theme;
    notifyListeners();
  }
}

class SelectedTheme {
  final ThemeData themeData;

  SelectedTheme({required this.themeData});
}

class AppThemes {
  static final lightTheme = SelectedTheme(
    themeData: ThemeData.light(),
  );

  static final darkTheme = SelectedTheme(
    themeData: ThemeData.dark(),
  );
}
