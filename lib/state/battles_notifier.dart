import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_battleships/models/challenge.dart';

class BattlesNotifier {
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

    // receiuved challenge
    final QuerySnapshot receivedQuerySnapshot = await _firestore
        .collection('challenges')
        .doc(targetId)
        .collection('received_challenges')
        .where('issuerId', isEqualTo: issuerId)
        .where('isAccepted', isEqualTo: false)
        .limit(1)
        .get();

    final QuerySnapshot issuedQuerySnapshot = await _firestore
        .collection('challenges')
        .doc(issuerId)
        .collection('issued_challenges')
        .where('targetId', isEqualTo: targetId)
        .where('isAccepted', isEqualTo: false)
        .limit(1)
        .get();

    if (receivedQuerySnapshot.docs.isNotEmpty) {
      // update the challenge timestamp for target
      await _firestore
          .collection('challenges')
          .doc(targetId)
          .collection('received_challenges')
          .doc(receivedQuerySnapshot.docs.first.id)
          .update(
        {'timestamp': timestamp},
      );
    } else {
      // create a new challenge for target
      await _firestore
          .collection('challenges')
          .doc(targetId)
          .collection('received_challenges')
          .add(challenge.toJson());
    }

    if (issuedQuerySnapshot.docs.isNotEmpty) {
      // update the challenge timestamp for target
      await _firestore
          .collection('challenges')
          .doc(issuerId)
          .collection('issued_challenges')
          .doc(issuedQuerySnapshot.docs.first.id)
          .update(
        {'timestamp': timestamp},
      );
    } else {
      // create a new challenge for target
      await _firestore
          .collection('challenges')
          .doc(issuerId)
          .collection('issued_challenges')
          .add(challenge.toJson());
    }

    // a notification is automatically sent to the target user by running a cloud function
    // when the firestore document is added or changed
  }

  // TODO get active challenges for logged in user
  Stream<QuerySnapshot> getActiveChallengesIssuedByUser() {
    final String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('challenges')
        .doc(userId)
        .collection('issued_challenges')
        .where('isAccepted', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getActiveChallengesReceivedByUser() {
    final String userId = _auth.currentUser!.uid;
    return _firestore
        .collection('challenges')
        .doc(userId)
        .collection('received_challenges')
        .where('isAccepted', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // TODO accept challenge from user

  // TODO decline challenge from user

  // TODO delete challenge issued by logged in user

  // TODO get battle history for logged in user
}
