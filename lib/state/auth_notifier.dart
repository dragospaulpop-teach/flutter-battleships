import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_battleships/main.dart';
import 'package:flutter_battleships/state/notifications_service.dart';
import 'package:provider/provider.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final NotificationsService _notificationsService;

  User? get user => _user;

  AuthNotifier() {
    BuildContext context = navigatorKey.currentContext!;
    _notificationsService =
        Provider.of<NotificationsService>(context, listen: false);

    _auth.authStateChanges().listen((User? user) async {
      _user = user;

      if (user != null) {
        await _notificationsService.initialize(user.uid);
      } else {
        _notificationsService.stopLisening();
      }

      notifyListeners();
    });
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(username);
        await user.reload();
        _user = _auth.currentUser;

        _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set({'username': username}, SetOptions(merge: true));

        notifyListeners();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<void> updateDisplayName(String username) async {
    if (_auth.currentUser != null) {
      try {
        User user = _auth.currentUser!;
        await user.updateDisplayName(username);
        await user.reload();
        _user = _auth.currentUser;

        notifyListeners();
      } on FirebaseAuthException catch (e) {
        throw Exception(e.message);
      }
    }
  }
}
