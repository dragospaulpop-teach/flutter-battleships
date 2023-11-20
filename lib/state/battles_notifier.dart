import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_battleships/models/challenge.dart';

class BattlesNotifier extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TODO issue a challenge to a user
  Future<void> issueChallenge(String targetId, String targetUsername) async {
    final String issuerId = _auth.currentUser!.uid;
    final String issuerUsername = _auth.currentUser!.displayName ?? '';
    final Timestamp timestamp = Timestamp.now();

    Challenge challenge = Challenge(
      issuerId: issuerId,
      issuerUsername: issuerUsername,
      targetId: targetId,
      targetUsername: targetUsername,
      isAccepted: false,
      timestamp: timestamp,
    );

    // check to see if there is already a challenge in progress
    // between the two users
    final QuerySnapshot querySnapshot = await _firestore
        .collection('challenges')
        .where('issuerId', isEqualTo: issuerId)
        .where('targetId', isEqualTo: targetId)
        .where('isAccepted', isEqualTo: false)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // update the challenge timestamp in firestore
      await _firestore
          .collection('challenges')
          .doc(querySnapshot.docs.first.id)
          .set(
        {'timestamp': timestamp},
        SetOptions(merge: true),
      );
    } else {
      // create a new challenge
      await _firestore.collection('challenges').add(challenge.toJson());
    }

    // send a notification to the target user
  }

  // TODO get active challenges for logged in user
  Stream<QuerySnapshot> getActiveChallengesIssuedByUser() {
    final String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('challenges')
        .where('issuerId', isEqualTo: userId)
        .where('isAccepted', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getActiveChallengesIssuedByOtherUser() {
    final String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('challenges')
        .where('targetId', isEqualTo: userId)
        .where('isAccepted', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // TODO accept challenge from user

  // TODO decline challenge from user

  // TODO delete challenge issued by logged in user

  // TODO get battle history for logged in user
}
