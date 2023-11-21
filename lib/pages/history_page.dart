import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'History'),
      body: const SafeArea(
        child: Center(
          child: Text("History"),
        ),
      ),
    );
  }
}
