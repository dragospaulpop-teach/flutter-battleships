import 'package:flutter/material.dart';
import 'package:flutter_battleships/pages/about_page.dart';
import 'package:flutter_battleships/pages/home_page.dart';

class AppRouter {
  AppRouter({required this.context, required this.toggleDarkMode}) {
    items = {
      '/': (context) => HomePage(toggleDarkMode: toggleDarkMode),
      '/about': (context) => const AboutPage(),
    };
  }

  final BuildContext context;
  final VoidCallback? toggleDarkMode;

  late Map<String, Widget Function(BuildContext)> items;

  Map<String, Widget Function(BuildContext)> get routes => items;
}
