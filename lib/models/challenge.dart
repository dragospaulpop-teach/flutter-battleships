import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String issuerId;
  final String issuerUsername;
  final String targetId;
  final String targetUsername;
  final bool isAccepted;
  final Timestamp timestamp;

  Challenge({
    required this.issuerId,
    required this.issuerUsername,
    required this.targetId,
    required this.targetUsername,
    required this.isAccepted,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'issuerId': issuerId,
      'issuerUsername': issuerUsername,
      'targetId': targetId,
      'targetUsername': targetUsername,
      'isAccepted': isAccepted,
      'timestamp': timestamp,
    };
  }
}
