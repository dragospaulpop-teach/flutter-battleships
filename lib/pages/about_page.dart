import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'About'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "About \"Naval Clash\"",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  "\"Naval Clash\" is an engaging online game of strategy and skill, where players battle on the high seas. Using Flutter technology for seamless mobile play, the game features secure Firebase authentication, ensuring a safe gaming environment. With real-time updates and player interactions managed through Firestore, every match is dynamic and unpredictable. Plus, with Firebase Cloud Messaging (FCM), players stay informed with notifications about game events and challenges. Dive into \"Naval Clash\" for an immersive battleship experience!",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
