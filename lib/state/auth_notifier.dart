import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_battleships/main.dart';
import 'package:flutter_battleships/state/notifications_service.dart';
import 'package:flutter_battleships/state/storage_service.dart';
import 'package:provider/provider.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storage = StorageService();
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
    await _notificationsService.stopLisening();

    return await _auth.signOut();
  }

  Future<void> updateDisplayName(String username) async {
    if (_auth.currentUser != null) {
      try {
        User user = _auth.currentUser!;
        await user.updateDisplayName(username);
        await user.reload();
        _user = _auth.currentUser;

        _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .set({'username': username}, SetOptions(merge: true));

        notifyListeners();
      } on FirebaseAuthException catch (e) {
        throw Exception(e.message);
      }
    }
  }

  Future<void> updateAvatarURL(String avatar) async {
    if (_auth.currentUser != null) {
      try {
        User user = _auth.currentUser!;
        await user.updatePhotoURL(avatar);
        await user.reload();
        _user = _auth.currentUser;
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        throw Exception(e.message);
      }
    }
  }

  Future<void> uploadAvatar(File image) async {
    if (_auth.currentUser != null) {
      try {
        String? url =
            await _storage.uploadAvatar(image, _auth.currentUser!.uid);
        await updateAvatarURL(url!);
      } on FirebaseAuthException catch (e) {
        throw Exception(e.message);
      }
    }
  }

  Future<void> deleteAccount(String password) async {
    try {
      await reauthenticate(password);
      await deleteUserDataFromFirestore();
      await deleteAuthInfo();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
    // print(password);
  }

  Future<void> deleteUserDataFromFirestore() async {
    String docID = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(docID).delete();
  }

  Future<void> deleteAuthInfo() async {
    await _user!.delete();
  }

  Future<void> reauthenticate(String password) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: _user!.email!,
      password: password,
    );
    await _user!.reauthenticateWithCredential(credential);
  }
}
