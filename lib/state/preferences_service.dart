import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<String?> getFCMToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString('fcmToken');
  }

  Future<void> saveFCMToken(String token) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('fcmToken', token);
  }
}
