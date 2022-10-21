import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  String get accessToken => _preferences?.getString(keyAccessToken) ?? '';
  set accessToken(String value) {
    _preferences?.setString(keyAccessToken, value);
  }

  String get username => _preferences?.getString(keyUsername) ?? '';
  set username(String value) {
    _preferences?.setString(keyUsername, value);
  }
}
final sharedPreferences = SharedPreferencesHelper();

const String keyAccessToken = "key_access_token";
const String keyUsername = "key_username";
