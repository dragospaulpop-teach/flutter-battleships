import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/app_drawer.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.toggleDarkMode});

  final VoidCallback? toggleDarkMode;

  @override
  Widget build(BuildContext context) {
    final AuthNotifier auth = Provider.of<AuthNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppbarWidget(title: 'Naval Clash'),
      drawer: AppDrawer(toggleDarkMode: toggleDarkMode),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome back to Naval Clash, ${auth.user!.displayName}!",
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  child: const Text('Challange Requests'),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/challenges'),
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  child: const Text('Battle History'),
                  onPressed: () => Navigator.of(context).pushNamed('/history'),
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  child: const Text('Challenge a friend'),
                  onPressed: () => Navigator.of(context).pushNamed('/users'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
