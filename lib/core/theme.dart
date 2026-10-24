import 'package:flutter/cupertino.dart';

abstract final class AppColors {
  static const background = Color(0xFF000000);
  static const accent = Color(0xFFFF375F);
  static const secondaryText = Color(0x99EBEBF5);
  static const separator = Color(0x1FFFFFFF);
}

const appTheme = CupertinoThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.accent,
  scaffoldBackgroundColor: AppColors.background,
);

abstract final class AppText {
  static const title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.white,
    letterSpacing: -0.3,
  );
  static const subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryText,
  );
  static const section = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: CupertinoColors.white,
    letterSpacing: -0.4,
  );
}
