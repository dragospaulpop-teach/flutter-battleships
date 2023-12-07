import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<String?> getFCMToken(String uid) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString('fcmToken-$uid');
  }

  Future<void> saveFCMToken(String token, String uid) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('fcmToken-$uid', token);
  }

  Future<void> deleteFCMToken(String uid) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('fcmToken-$uid');
  }
}
