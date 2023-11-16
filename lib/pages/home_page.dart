import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/app_drawer.dart';
import 'package:flutter_battleships/components/battle_history.dart';
import 'package:flutter_battleships/components/login_or_signup_form.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.toggleDarkMode});

  final VoidCallback? toggleDarkMode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthNotifier(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Naval Clash'),
        ),
        drawer: AppDrawer(toggleDarkMode: toggleDarkMode),
        body: SafeArea(
          child: Center(
            child: Consumer<AuthNotifier>(
              builder: (context, auth, child) {
                return auth.user != null
                    ? BattleHistory(auth: auth)
                    : const LoginOrSignupForm();
              },
            ),
          ),
        ),
      ),
    );
  }
}
