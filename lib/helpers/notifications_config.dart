import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> initializeNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await messaging.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔔 Foreground Message: ${message.notification?.title}');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔔 Background Message: ${message.messageId}');
}
