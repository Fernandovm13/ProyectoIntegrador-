import 'package:screen_protector/screen_protector.dart';

class ScreenProtectionService {
  static Future<void> enable() async {
    await ScreenProtector.protectDataLeakageOn();
  }

  static Future<void> disable() async {
    await ScreenProtector.protectDataLeakageOff();
  }
}