import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_battleships/main.dart';
import 'package:flutter_battleships/state/preferences_service.dart';

class NotificationsService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

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
      navigatorKey.currentState!.pushNamed(
        '/challenges',
      );
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

  Future<void> sendBattleNotification(String receiverId) async {
    final DocumentSnapshot receiver =
        await _firestore.collection('users').doc(receiverId).get();

    if (receiver.exists) {
      // call cloud function to send notification
    }
  }
}
