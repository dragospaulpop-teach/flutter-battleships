import 'package:flutter/material.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:flutter_battleships/state/notifications_service.dart';
import 'package:provider/provider.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppbarWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBarContent(title: title);
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // AppBar's default height
}

class AppBarContent extends StatelessWidget {
  final String title;
  const AppBarContent({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(builder: (context, auth, child) {
      return AppBar(
        title: Text(title),
        actions: auth.user != null
            ? [
                Consumer<NotificationsService>(
                    builder: (context, notifications, child) {
                  return IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                    icon: Badge(
                      label: Text(notifications.messages
                          .where((message) => message.isSeen == false)
                          .length
                          .toString()),
                      child: const Icon(Icons.notifications),
                    ),
                  );
                }),
                IconButton(
                  onPressed: () => auth.signOut(),
                  icon: const Icon(Icons.logout),
                ),
              ]
            : [],
      );
    });
  }
}
