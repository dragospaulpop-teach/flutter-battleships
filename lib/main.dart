import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_battleships/config/theme.dart';
import 'package:flutter_battleships/firebase_options.dart';
import 'package:flutter_battleships/router.dart';
import 'package:flutter_battleships/state/notifications_service.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // value of light is system at first
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Initialize based on system preference
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isDarkMode =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
      });
    });
  }

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes:
          AppRouter(context: context, toggleDarkMode: toggleDarkMode).routes,
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'Flutter Battleships Demo',
      theme: ThemeConfiguration.theme,
      darkTheme: ThemeConfiguration.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
