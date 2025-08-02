// lib/bootstrap.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'helpers/firebase_init.dart';
import 'helpers/hive.dart';
import 'helpers/notifications_config.dart';

const _prefFirstTime = 'is_first_time';

/// يعيد اسم الـ route الذي يبدأ عنده التطبيق:
/// '/splash' لأول مرة، '/' للمستخدمين المسجلين، '/login' للزوار
Future<String> determineStartRoute(prefs) async {
  await initializeFirebase();
  await initializeHive();
  await initializeNotifications();
  final isFirst = prefs.getBool(_prefFirstTime) ?? true;
  if (isFirst) {
    print("it is first time");
    await prefs.setBool(_prefFirstTime, false);
    return '/splash';
  }

  final user = FirebaseAuth.instance.currentUser;
  print ("user is ${user}");
  if (user != null) {
    return '/';
  }

  return '/splash';
}
