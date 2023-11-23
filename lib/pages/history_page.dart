import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppbarWidget(title: 'History'),
      body: SafeArea(
        child: Center(
          child: Text("History"),
        ),
      ),
    );
  }
}
