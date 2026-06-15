import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'secure_storage_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log("Handling a background message: ${message.messageId}");
  
  if (message.data['action'] == 'remote_wipe') {
    developer.log("Remote wipe action received in background! Purging sensitive data.");
    await SecureStorageService.clearSensitiveData();
    FcmService.onWipeTriggered.value = !FcmService.onWipeTriggered.value;
  }
}

class FcmService {
  static final ValueNotifier<bool> onWipeTriggered = ValueNotifier<bool>(false);

  static Future<void> initialize() async {
    try {
      final messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      developer.log('User granted permission: ${settings.authorizationStatus}');

      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        developer.log('Got a message whilst in the foreground!');
        developer.log('Message data: ${message.data}');

        if (message.notification != null) {
          developer.log('Message also contained a notification: ${message.notification!.title}');
        }

        if (message.data['action'] == 'remote_wipe') {
          developer.log('Remote wipe action received in foreground! Purging sensitive data.');
          await SecureStorageService.clearSensitiveData();
          onWipeTriggered.value = !onWipeTriggered.value;
        }
      });

      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _handleOpenedMessage(initialMessage);
      }

      FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);

    } catch (e) {
      developer.log("Error initializing FCM Service: $e");
    }
  }

  static void _handleOpenedMessage(RemoteMessage message) async {
    developer.log("App opened via message: ${message.messageId}");
    if (message.data['action'] == 'remote_wipe') {
      developer.log('Remote wipe action received from opened app! Purging sensitive data.');
      await SecureStorageService.clearSensitiveData();
      onWipeTriggered.value = !onWipeTriggered.value;
    }
  }

  static Future<String?> getDeviceToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      developer.log("Error getting device token: $e");
      return null;
    }
  }
}
