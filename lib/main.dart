import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_battleships/config/theme.dart';
import 'package:flutter_battleships/firebase_options.dart';
import 'package:flutter_battleships/router.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:flutter_battleships/state/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthNotifier()),
        ChangeNotifierProvider(create: (context) => NotificationsService()),
      ],
      child: const MainApp(),
    ),
  );
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
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

      authNotifier.addListener(() {
        if (authNotifier.user == null) {
          navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/login', (route) => false);
        } else {
          navigatorKey.currentState
              ?.pushNamedAndRemoveUntil('/', (route) => false);
        }
      });

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
      initialRoute: '/',
      onGenerateRoute:
          AppRouter(context: context, toggleDarkMode: toggleDarkMode)
              .generateRoute,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Battleships Demo',
      theme: ThemeConfiguration.theme,
      darkTheme: ThemeConfiguration.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
