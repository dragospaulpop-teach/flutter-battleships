import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String title;
  final String body;
  final Timestamp timestamp;

  Message({required this.title, required this.body, required this.timestamp});
}
