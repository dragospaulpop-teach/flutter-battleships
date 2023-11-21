import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_battleships/models/message.dart';
import 'package:flutter_battleships/state/preferences_service.dart';

class NotificationsService extends ChangeNotifier {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<Message> messages = [];

  Future<void> initialize() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    // this only handles one device per user
    // for multiple devices we need to store an array of tokens both in firestore and in our shared preferences

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final String? localToken = await PreferencesService().getFCMToken();
      final String? token = await _firebaseMessaging.getToken();

      if (localToken != token) {
        PreferencesService().saveFCMToken(token!);
        saveTokenToFirestore(token);
      }
    }

    setupNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      messages.add(Message(
        title: message.notification!.title!,
        body: message.notification!.body!,
        timestamp: Timestamp.fromDate(message.sentTime!),
      ));

      notifyListeners();
    }
  }

  void setupNotifications() async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }

  void saveTokenToFirestore(token) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }
}
