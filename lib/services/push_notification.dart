import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotifications {
  static sendNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    fcm.subscribeToTopic('Announcement');
  }
}
