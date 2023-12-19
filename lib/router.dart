import 'package:flutter/material.dart';
import 'package:flutter_battleships/pages/about_page.dart';
import 'package:flutter_battleships/pages/challenges_page.dart';
import 'package:flutter_battleships/pages/history_page.dart';
import 'package:flutter_battleships/pages/home_page.dart';
import 'package:flutter_battleships/pages/login_or_signup_page.dart';
import 'package:flutter_battleships/pages/notifications_page.dart';
import 'package:flutter_battleships/pages/users_page.dart';
import 'package:flutter_battleships/pages/battle_screen.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:provider/provider.dart';

class AppRouter {
  AppRouter({required this.context, required this.toggleDarkMode}) {
    routes = {
      '/': (context) => HomePage(toggleDarkMode: toggleDarkMode),
      '/about': (context) => const AboutPage(),
      '/challenges': (context) => ChallengesPage(),
      '/notifications': (context) => const NotificationsPage(),
      '/history': (context) => const HistoryPage(),
      '/users': (context) => UsersPage(),
      '/battlescreen': (context) => const BattleScreen(),
      '/login': (context) => LoginOrSignupPage(
            toggleDarkMode: toggleDarkMode,
          )
    };
  }

  final BuildContext context;
  final VoidCallback? toggleDarkMode;

  late Map<String, Widget Function(BuildContext)> routes;

  Route<dynamic>? generateRoute(RouteSettings settings) {
    final routeBuilder = routes[settings.name];

    final AuthNotifier auth = Provider.of<AuthNotifier>(context, listen: false);

    if (auth.user == null &&
        settings.name != '/login' &&
        settings.name != '/about') {
      return MaterialPageRoute(
        builder: (context) => LoginOrSignupPage(
          toggleDarkMode: toggleDarkMode,
        ),
      );
    }

    if (routeBuilder != null) {
      return MaterialPageRoute(
        builder: (context) => routeBuilder(context),
        settings: settings,
      );
    }

    return null;
  }
}
