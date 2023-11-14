import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/player_board.dart';
import 'package:flutter_battleships/config/theme.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
      title: 'Flutter Battleships Demo',
      theme: ThemeConfiguration.theme,
      darkTheme: ThemeConfiguration.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        bool isLandscape = constraints.maxWidth > constraints.maxHeight;
        double? height = isLandscape
            ? null
            : MediaQuery.of(context).size.height - kToolbarHeight * 1.5;
        double? width = isLandscape ? MediaQuery.of(context).size.width : null;
        Widget mainLayout;

        if (isLandscape) {
          mainLayout = Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: width! / 2,
                child: PlayerBoard(player: 'enemy'),
              ),
              // Divider(thickness: 2),
              Container(
                width: width! / 2,
                child: PlayerBoard(player: 'owner'),
              ),
            ],
          );
        } else {
          mainLayout = const Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PlayerBoard(player: 'enemy'),
              Divider(thickness: 2),
              PlayerBoard(player: 'owner'),
            ],
          );
        }

        return Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text('Flutter Battleships'),
              actions: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: isDarkMode ? Colors.white : Colors.black,
                    size: 24.0,
                  ),
                  onPressed: () => toggleDarkMode(),
                )
              ]),
          body: SafeArea(
            child: SizedBox(
              height: height,
              width: width,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: mainLayout,
              ),
            ),
          ),
        );
      }),
    );
  }
}
