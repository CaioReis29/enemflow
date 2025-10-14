import 'package:enem_app/core/di/container_injections.dart';
import 'package:enem_app/core/themes/app_color.dart';
import 'package:enem_app/core/themes/app_text_style.dart';
import 'package:enem_app/data/shared/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ChangeNotifier {
  final SharedPreferenceService _service = getIt<SharedPreferenceService>();

  bool _isDarkMode = true;
  ThemeData _themeData;

  AppTheme() : _themeData = _darkTheme {
    _loadThemePreference();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color buttonTextColor,
    required Color floatingButtonColor,
  }) {
    return ThemeData(
      brightness: brightness,
      primaryTextTheme: TextTheme(
        bodyMedium: AppTextStyle.poppinsW600s18.copyWith(color: buttonTextColor),
      ),
      cardTheme: CardThemeData(
        color: brightness == Brightness.dark ? AppColor.grey : AppColor.white,
        elevation: 6,
      ),
      fontFamily: GoogleFonts.poppins().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      primaryColor: primaryColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: floatingButtonColor,
        elevation: 6,
      ),
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyle.poppinsW600s18.copyWith(color: buttonTextColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          overlayColor: AppColor.black,
          backgroundColor: primaryColor,
        ),
      ),
    );
  }

  static ThemeData get _darkTheme => _buildTheme(
        brightness: Brightness.dark,
        primaryColor: AppColor.primary,
        buttonTextColor: AppColor.white,
        floatingButtonColor: AppColor.white,
      );

  static ThemeData get _lightTheme => _buildTheme(
        brightness: Brightness.light,
        primaryColor: AppColor.primary,
        buttonTextColor: AppColor.white,
        floatingButtonColor: AppColor.black,
      );

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _updateTheme();
    _saveThemePreference();
  }

  void _updateTheme() {
    _themeData = _isDarkMode ? _darkTheme : _lightTheme;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    await _service.saveThemePreference(_isDarkMode);
  }

  Future<void> _loadThemePreference() async {
    _isDarkMode = _service.getThemePreference() ?? true;
    _updateTheme();
  }
}
