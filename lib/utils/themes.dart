import 'package:flutter/cupertino.dart';
import 'constants.dart';

class AppTheme {
  static CupertinoThemeData lightTheme = CupertinoThemeData(
    primaryColor: AppConstants.primaryColor,
    barBackgroundColor: AppConstants.backgroundColor,
    scaffoldBackgroundColor: AppConstants.backgroundColor,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppConstants.primaryColor,
      textStyle: const TextStyle(
        fontFamily: "SF Pro Text",
        fontSize: 16,
        color: CupertinoColors.black,
      ),
    ),
  );
}
