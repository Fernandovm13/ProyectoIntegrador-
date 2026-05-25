import 'package:flutter/services.dart';

class FakeGpsService {

  static const MethodChannel _channel =
  MethodChannel('fake_gps_detector');

  static Future<bool> isFakeGpsEnabled() async {

    try {

      final bool result =
      await _channel.invokeMethod(
        'isFakeGpsEnabled',
      );

      return result;

    } catch (e) {

      return false;
    }
  }
}