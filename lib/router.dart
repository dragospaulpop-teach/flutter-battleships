import 'package:flutter/material.dart';
import 'package:flutter_battleships/pages/about_page.dart';
import 'package:flutter_battleships/pages/challenges_page.dart';
import 'package:flutter_battleships/pages/history_page.dart';
import 'package:flutter_battleships/pages/home_page.dart';
import 'package:flutter_battleships/pages/users_page.dart';

class AppRouter {
  AppRouter({required this.context, required this.toggleDarkMode}) {
    items = {
      '/': (context) => HomePage(toggleDarkMode: toggleDarkMode),
      '/about': (context) => const AboutPage(),
      '/challenges': (context) => ChallengesPage(),
      '/history': (context) => const HistoryPage(),
      '/users': (context) => UsersPage(),
    };
  }

  final BuildContext context;
  final VoidCallback? toggleDarkMode;

  late Map<String, Widget Function(BuildContext)> items;

  Map<String, Widget Function(BuildContext)> get routes => items;
}
