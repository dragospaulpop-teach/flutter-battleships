import 'package:flutter/material.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';

class BattleHistory extends StatelessWidget {
  const BattleHistory({super.key, required this.auth});

  final AuthNotifier auth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            child: const Text('Active Challanges'),
            onPressed: () => Navigator.of(context).pushNamed('/challenges'),
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
    );
  }
}
