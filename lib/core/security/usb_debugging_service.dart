import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UsbDebuggingService {
  static const MethodChannel _channel = MethodChannel('usb_debugging_channel');

  static Future<bool> isUsbDebuggingEnabled() async {
    // Exclude local debug mode so developers can compile/run the app
    // if (kDebugMode) {
    // return false;
    // }
    
    try {
      final bool isEnabled = await _channel.invokeMethod('isUsbDebuggingEnabled');
      return isEnabled;
    } on PlatformException catch (e) {
      debugPrint("Error detecting USB debugging status: $e");
      return false;
    }
  }
}
