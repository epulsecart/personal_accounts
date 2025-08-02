// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../data/user_model.dart';

class AuthService {
  final FirebaseAuth       _auth      = FirebaseAuth.instance;
  final FirebaseFirestore  _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging  _messaging = FirebaseMessaging.instance;

  Future<void> verifyPhoneNumber({
    required String phone,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? forceResendingToken,
    Duration timeout = const Duration(seconds: 60),
  })
  async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: timeout,
      forceResendingToken: forceResendingToken,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  /// ينشئ المستند أو يُحدّثه بجميع الحقول الواردة
  Future<UserModel> _createOrFetchUserDoc(
      User firebaseUser,
      LoginMethod method, {
        String? name,
        String? email,
        String? phone,
      })
  async {
    final uid    = firebaseUser.uid;
    final docRef = _firestore.collection('users').doc(uid);
    final now    = DateTime.now();
    final token  = await _messaging.getToken();

    final data = <String, dynamic>{
      'fcmToken':    token,
      'lastLoginAt': Timestamp.fromDate(now),
    };
    if (name  != null) data['name']  = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;

    final snapshot = await docRef.get();
    if (snapshot.exists) {
      await docRef.update(data);
    } else {
      data.addAll({
        'loginMethod':   method.name,
        'createdAt':     Timestamp.fromDate(now),
        'platform':      defaultTargetPlatform.name,
        'interests': [
          'personal', 'shared', 'project'
        ]
      });
      await docRef.set(data);
    }

    final fresh = await docRef.get();
    return UserModel.fromFirestore(fresh);
  }

  /// يتأكد من عدم وجود مستخدم آخر بنفس الإيميل/الهاتف
  Future<UserModel?> _ensureUnique({String? email, String? phone, String? password}) async {
    final currentUid = _auth.currentUser?.uid;
    if (email != null) {
      final q = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (q.docs.any((d) {
        print ("d.get('loginMethod') is ${d.get('loginMethod')}");
        return d.id != currentUid;
      })) {
        if (q.docs.any((d)=> d.get('loginMethod')=='email')){
          print ("the email is $email i will log in instead");
          final UserModel da = await signInWithEmail(email: email, password: password??'');
          return da;
        }else throw Exception('This email is already in use.');
      }
    }
    if (phone != null) {
      final q = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();
      if (q.docs.any((d) => d.id != currentUid)) {
        throw Exception('This phone number is already in use.');
      }
    }
    return null;
  }

  /// تسجيل أو ربط حساب Email
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  })
  async {
    final current = _auth.currentUser;
    UserModel? resultt  = await _ensureUnique(email: email, password: password);
    if (resultt!=null) return resultt;
    // لو مجهول، نربط فقط
    if (current != null && current.isAnonymous) {
      final cred = EmailAuthProvider.credential(email: email, password: password);
      final linkResult = await current.linkWithCredential(cred);
      return _createOrFetchUserDoc(
        linkResult.user!, LoginMethod.email,
         email: email,
      );
    }
    // خلاف ذلك، ننشئ مستخدم جديد
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password).catchError((e){
          print ("can not sign up with the email $e");
          throw e;
    });
    return _createOrFetchUserDoc(
      result.user!, LoginMethod.email,
       email: email,
    );
  }

  /// تسجيل الدخول عبر Email (أو الربط لو كان مجهول)
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  })
  async {
    final current = _auth.currentUser;
    final cred = EmailAuthProvider.credential(email: email, password: password);

    if (current != null && current.isAnonymous) {
      // await _ensureUnique(email: email);
      final linkResult = await current.linkWithCredential(cred);
      return _createOrFetchUserDoc(
        linkResult.user!, LoginMethod.email,
        email: email,
      );
    }
    final result = await _auth.signInWithCredential(cred);
    return _createOrFetchUserDoc(
      result.user!, LoginMethod.email,
    );
  }

  /// تسجيل الدخول المجهول
  Future<UserModel> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    return _createOrFetchUserDoc(
      result.user!, LoginMethod.anonymous,
    );
  }

  /// تسجيل أو ربط حساب Google
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was aborted by user.');
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken:     googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final current = _auth.currentUser;
    User firebaseUser;
    if (current != null && current.isAnonymous) {
      final email = googleUser.email;
      await _ensureUnique(email: email);
      final linkResult = await current.linkWithCredential(credential);
      firebaseUser = linkResult.user!;
    } else {
      final result = await _auth.signInWithCredential(credential);
      firebaseUser = result.user!;
    }

    return _createOrFetchUserDoc(
      firebaseUser, LoginMethod.google,
      email: firebaseUser.email,
    );
  }

  /// تسجيل أو ربط حساب Phone
  Future<UserModel> signInWithPhone({
    required String phone,
    required String verificationId,
    required String smsCode,
  })
  async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode:        smsCode,
    );

    final current = _auth.currentUser;
    User firebaseUser;
    if (current != null && current.isAnonymous) {
      await _ensureUnique(phone: phone);
      final linkResult = await current.linkWithCredential(credential);
      firebaseUser = linkResult.user!;
    } else {
      final result = await _auth.signInWithCredential(credential);
      firebaseUser = result.user!;
    }

    return _createOrFetchUserDoc(
      firebaseUser, LoginMethod.phone,
      phone: phone,
    );
  }

  /// تسجيل أو ربط حساب Apple (iOS فقط)
  Future<UserModel> signInWithApple() async {
    final rawNonce = _generateNonce();
    final nonce    = _sha256ofString(rawNonce);

    final appleCredentialResponse = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken:      appleCredentialResponse.identityToken,
      accessToken:  appleCredentialResponse.authorizationCode,
      rawNonce:     rawNonce,
    );

    final current = _auth.currentUser;
    User firebaseUser;
    final email = appleCredentialResponse.email;
    if (current != null && current.isAnonymous) {
      if (email != null) await _ensureUnique(email: email);
      final linkResult = await current.linkWithCredential(oauthCredential);
      firebaseUser = linkResult.user!;
    } else {
      final result = await _auth.signInWithCredential(oauthCredential);
      firebaseUser = result.user!;
    }

    return _createOrFetchUserDoc(
      firebaseUser, LoginMethod.apple,
      email: email,
      name: appleCredentialResponse.givenName != null
          ? "${appleCredentialResponse.givenName} ${appleCredentialResponse.familyName}"
          : null,
    );
  }

  /// تسجيل الخروج
  Future<void> signOut() => _auth.signOut();

  /// بيانات المستخدم الحالي من Firestore
  Future<UserModel> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromFirestore(doc);
  }

  /// تحديث الاهتمامات في Firestore
  Future<void> updateUserInterests(String uid, List<String> interests) {
    return _firestore.collection('users').doc(uid).update({
      'interests': interests,
    });
  }
  Future<void> updateUserSettings({
    required String uid,
    String? themeMode,
    String? language,
    bool? notificationsEnabled,
    bool? debtsReminder,
    bool? dailyReminder,
    bool? newsUpdates,
  })
  {
    final data = <String, dynamic>{};
    if (themeMode           != null) data['themeMode']            = themeMode;
    if (language            != null) data['language']             = language;
    if (notificationsEnabled!= null) data['notificationsEnabled'] = notificationsEnabled;
    if (debtsReminder       != null) data['debtsReminder']        = debtsReminder;
    if (dailyReminder       != null) data['dailyReminder']        = dailyReminder;
    if (newsUpdates         != null) data['newsUpdates']          = newsUpdates;
    return _firestore.collection('users').doc(uid).update(data);
  }

  // ———————— مساعدة Apple Sign-In ————————

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final rand    = Random.secure();
    return List.generate(length, (_) => charset[rand.nextInt(charset.length)]).join();
  }

  String _sha256ofString(String input) {
    final bytes  = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  Future<void> updateUserProfile({
    required String name,
    required String uid,
    required String phone,
  }) async {
    // ensure no other user has this phone
    await _ensureUnique(phone: phone);
    // write only the two fields
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
    });
  }
}
