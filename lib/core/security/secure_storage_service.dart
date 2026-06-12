import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  static const String _keyToken = 'auth_token';
  static const String _keyInactivityTime = 'inactivity_time';

  static const String _keyUserFullName = 'user_fullname';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserAddress = 'user_address';

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


  static Future<void> populateSensitiveUserData() async {
    await _storage.write(key: _keyUserFullName, value: 'Fernando Vélez M.');
    await _storage.write(key: _keyUserEmail, value: 'fernando.velez@correo.com');
    await _storage.write(key: _keyUserPhone, value: '+52 555 123 4567');
    await _storage.write(key: _keyUserAddress, value: 'Av. Universidad 123, Coyoacán, CDMX');
  }

  static Future<Map<String, String?>> getSensitiveUserData() async {
    return {
      'fullname': await _storage.read(key: _keyUserFullName),
      'email': await _storage.read(key: _keyUserEmail),
      'phone': await _storage.read(key: _keyUserPhone),
      'address': await _storage.read(key: _keyUserAddress),
    };
  }

  static Future<void> clearSensitiveData() async {
    await _storage.delete(key: _keyUserFullName);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUserPhone);
    await _storage.delete(key: _keyUserAddress);
    await clearSessionData();
  }
}
