import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _user;

  AuthNotifier() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
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
      throw Exception(e.code);
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

        notifyListeners();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
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
        throw Exception(e.code);
      }
    }
  }
}
