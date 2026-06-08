import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _keyToken = 'auth_token';
  static const String _keyInactivityTime = 'inactivity_time';

  static Future<void> saveSessionData(String token, String inactivityTime) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyInactivityTime, value: inactivityTime);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<String?> getInactivityTime() async {
    return await _storage.read(key: _keyInactivityTime);
  }

  static Future<void> clearSessionData() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyInactivityTime);
  }
}
