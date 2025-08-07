// lib/models/user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum LoginMethod { email, phone, google, anonymous, apple }

class UserModel {
  final String uid;
  final String? name;
  final String? email;
  final String? phone;
  final LoginMethod loginMethod;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final String platform;
  final List<String> interests;

  // ─────────────── New settings fields ───────────────
  final String  themeMode;            // 'light' or 'dark'
  final String  language;             // 'en' or 'ar'
  final bool    notificationsEnabled; // master switch
  final bool    debtsReminder;        // reminder for debts
  final bool    dailyReminder;        // daily “financial note” reminder
  final bool    newsUpdates;          // news & updates notifications

  UserModel({
    required this.uid,
    this.name,
    this.email,
    this.phone,
    required this.loginMethod,
    this.fcmToken,
    required this.createdAt,
    required this.lastLoginAt,
    required this.platform,
    this.interests = const [],
    // defaults:
    this.themeMode            = 'dark',
    this.language             = 'en',
    this.notificationsEnabled = true,
    this.debtsReminder        = true,
    this.dailyReminder        = true,
    this.newsUpdates          = true,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name:  data['name']  as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      loginMethod: LoginMethod.values.byName(data['loginMethod'] as String),
      fcmToken: data['fcmToken'] as String?,
      createdAt:   (data['createdAt']   as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
      platform:    data['platform'] as String,
      interests:   (data['interests'] as List<dynamic>?)
          ?.cast<String>() ?? [],
      themeMode:            data['themeMode']            as String? ?? 'dark',
      language:             data['language']             as String? ?? 'en',
      notificationsEnabled: data['notificationsEnabled'] as bool?   ?? true,
      debtsReminder:        data['debtsReminder']        as bool?   ?? true,
      dailyReminder:        data['dailyReminder']        as bool?   ?? true,
      newsUpdates:          data['newsUpdates']          as bool?   ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'name':                name,
    'email':               email,
    'phone':               phone,
    'loginMethod':         loginMethod.name,
    'fcmToken':            fcmToken,
    'createdAt':           createdAt,
    'lastLoginAt':         lastLoginAt,
    'platform':            platform,
    'interests':           interests,
    // ─────────────── Export new fields ───────────────
    'themeMode':           themeMode,
    'language':            language,
    'notificationsEnabled':notificationsEnabled,
    'debtsReminder':       debtsReminder,
    'dailyReminder':       dailyReminder,
    'newsUpdates':         newsUpdates,
  };

  UserModel copyWith({
    List<String>? interests,
    String? themeMode,
    String? language,
    bool? notificationsEnabled,
    bool? debtsReminder,
    bool? dailyReminder,
    bool? newsUpdates,
  }) {
    return UserModel(
      uid:               uid,
      name:              name,
      email:             email,
      phone:             phone,
      loginMethod:       loginMethod,
      fcmToken:          fcmToken,
      createdAt:         createdAt,
      lastLoginAt:       lastLoginAt,
      platform:          platform,
      interests:         interests ?? this.interests,
      themeMode:         themeMode           ?? this.themeMode,
      language:          language            ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      debtsReminder:     debtsReminder       ?? this.debtsReminder,
      dailyReminder:     dailyReminder       ?? this.dailyReminder,
      newsUpdates:       newsUpdates         ?? this.newsUpdates,
    );
  }
}
