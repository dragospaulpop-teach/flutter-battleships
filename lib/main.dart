import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/grid.dart';
import 'package:flutter_battleships/components/ships.dart';

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
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.blueGrey[50],
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.brown[200],
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: Colors.brown[900],
          elevation: 0.0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
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
            height: MediaQuery.of(context).size.height - kToolbarHeight * 1.5,
            child: SingleChildScrollView(
              // padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/opponent.jpg',
                        ),
                        fit: BoxFit.fill,
                        opacity: 0.25,
                        // colorFilter: ColorFilter.mode(
                        //   Colors.red.withOpacity(0.25),
                        //   BlendMode.darken,
                        // ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Enemy',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ShipsWidget(),
                            ),
                            Expanded(
                              flex: 2,
                              child: GridWidget(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 8.0,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/player.jpg',
                        ),
                        fit: BoxFit.fill,
                        opacity: 0.25,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'You',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ShipsWidget(),
                            ),
                            Expanded(
                              flex: 2,
                              child: GridWidget(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
