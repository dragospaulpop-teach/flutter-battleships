import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  // final String id;
  final String title;
  final String body;
  final Timestamp timestamp;
  final bool isSeen;

  Message({
    // required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isSeen,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'isSeen': isSeen
    };
  }
}
