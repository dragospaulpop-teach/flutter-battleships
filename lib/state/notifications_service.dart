import 'dart:async';

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

  StreamSubscription? messagesListener;

  Future<void> initialize(String uid) async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // Call a method to send the new token to your backend
      PreferencesService().saveFCMToken(newToken, uid);
      saveTokenToFirestore(newToken);
    });

    // this only handles one device per user
    // for multiple devices we need to store an array of tokens both in firestore and in our shared preferences

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final String? localToken = await PreferencesService().getFCMToken(uid);
      final String? token = await _firebaseMessaging.getToken();

      if (localToken != token) {
        PreferencesService().saveFCMToken(token!, uid);
        saveTokenToFirestore(token);
      }
    }

    setupNotifications();
    setupMessages();
  }

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      // messages.add(Message(
      //   title: message.notification!.title!,
      //   body: message.notification!.body!,
      //   isSeen: false,
      //   timestamp: Timestamp.fromDate(message.sentTime!),
      // ));

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

  Future<void> removeTokenFromFirestore() async {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({'token': null}, SetOptions(merge: true));
  }

  void setupMessages() {
    final String userId = _auth.currentUser!.uid;
    messagesListener = _firestore
        .collection('notifications')
        .doc(userId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((event) {
      messages.clear();
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          Message message = Message(
            // id: doc.id,
            title: doc['title'],
            body: doc['body'],
            timestamp: doc['timestamp'],
            isSeen: doc['isSeen'],
          );
          messages.add(message);
        }
      }
      notifyListeners();
    });
  }

  Future<void> stopLisening() async {
    // stop listening to messages in the firestore collection
    messagesListener?.cancel();
    // remove token from local storage
    await PreferencesService().deleteFCMToken(_auth.currentUser!.uid);
    // remove tokenb from firestore
    await removeTokenFromFirestore();
  }
}
