import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';
import 'package:flutter_battleships/models/message.dart';
import 'package:flutter_battleships/state/notifications_service.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(title: 'Notifications'),
      body: SafeArea(
        child: Consumer<NotificationsService>(
          builder: (context, notifications, child) {
            return notifications.messages.isNotEmpty
                ? ListView(
                    shrinkWrap: true,
                    children: notifications.messages
                        .map((message) =>
                            buildMessageTile(context, message, notifications))
                        .toList(),
                  )
                : const Center(child: Text("No messages"));
          },
        ),
      ),
    );
  }

  ListTile buildMessageTile(
    BuildContext context,
    Message message,
    NotificationsService notifications,
  ) {
    return ListTile(
      tileColor: message.isSeen
          ? null
          : Theme.of(context).primaryColor.withOpacity(0.5),
      title: Text(
        message.title,
        style: TextStyle(
            fontWeight: message.isSeen ? FontWeight.w600 : FontWeight.w900),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message.body),
          Text(message.timestamp.toDate().toString().substring(0, 19)),
        ],
      ),
      isThreeLine: true,
      onTap: () => {
        notifications.markAsSeen(message.id),
      },
    );
  }
}
