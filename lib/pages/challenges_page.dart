import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';
import 'package:flutter_battleships/state/battles_notifier.dart';

class ChallengesPage extends StatelessWidget {
  ChallengesPage({super.key});

  final BattlesNotifier _battlesNotifier = BattlesNotifier();

  // Future<void> deleteChallenge(BuildContext context, String challengeId) {

  // }

  Future<void> acceptOrDeclineChallenge(
      BuildContext context, String challengeId) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content:
              const Text('Do you want to accept or decline this challenge?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Decline',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Accept',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // accept challenge
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(title: 'Challenges'),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Challenges you made",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: _battlesNotifier.getActiveChallengesIssuedByUser(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return ListTile(
                      leading: const Icon(Icons.arrow_right),
                      title: Text(data['targetUsername']),
                      subtitle: Text(data['timestamp']
                          .toDate()
                          .toString()
                          .substring(0, 19)),
                      contentPadding: const EdgeInsets.all(16),
                      trailing: data['isAccepted']
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : const Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                      onTap: () => {} // deleteChallenge(context, document.id),
                      );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            "Challenges you received",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: _battlesNotifier.getActiveChallengesReceivedByUser(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return ListTile(
                    leading: const Icon(Icons.arrow_left),
                    title: Text(data['issuerUsername']),
                    subtitle: Text(
                        data['timestamp'].toDate().toString().substring(0, 19)),
                    contentPadding: const EdgeInsets.all(16),
                    trailing: const Icon(Icons.approval),
                    onTap: () => acceptOrDeclineChallenge(context, document.id),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
