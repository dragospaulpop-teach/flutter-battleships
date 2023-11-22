import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadAvatar(File imageFile, String userId) async {
    Reference storageRef = _storage.ref().child('images/$userId');

    TaskSnapshot uploadTask = await storageRef.putFile(imageFile);
    String downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }
}
