import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_battleships/state/battles_notifier.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BattlesNotifier _battlesNotifier = BattlesNotifier();

  Future<void> issueChallenge(
      BuildContext context, String receiverId, String receiverUsername) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: const Text(
              'Are you sure you want to send a challenge to this user?'),
          actions: [
            TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
                child: Text('Confirm',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _battlesNotifier.issueChallenge(receiverId, receiverUsername);
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs
                .where((element) =>
                    false ==
                    element.id
                        .contains(_auth.currentUser?.uid.toString() ?? ""))
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return _auth.currentUser?.uid == document.id
                  ? Container()
                  : ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(data['username']),
                      contentPadding: const EdgeInsets.all(16),
                      trailing: const Icon(Icons.sports),
                      onTap: () => issueChallenge(
                          context, document.id, data['username']),
                    );
            }).toList(),
          );
        },
      ),
    );
  }
}
