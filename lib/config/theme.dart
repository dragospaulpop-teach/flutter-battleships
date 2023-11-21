import "package:flutter/material.dart";

class ThemeConfiguration {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.blueGrey[50],
    primaryColor: Colors.brown[200],
    badgeTheme: BadgeThemeData(
      backgroundColor: Colors.brown[900],
      textColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      color: Colors.brown[200],
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.blueGrey[900],
    primaryColor: Colors.brown[900],
    badgeTheme: BadgeThemeData(
      backgroundColor: Colors.brown[200],
      textColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      color: Colors.brown[900],
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
