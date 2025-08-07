// lib/state/auth_provider.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/user_model.dart';
import '../data/user_module/categories.dart';
import '../data/user_module/sync_record.dart';
import '../data/user_module/templates.dart';
import '../data/user_module/transactions.dart';
import '../helpers/hive.dart';
import '../services/auth_service.dart';

enum AuthStatus { uninitialized, authenticating, authenticated, unauthenticated, codeSent }

class AuthProvider extends ChangeNotifier {
  final _statusNotifier = ValueNotifier<AuthStatus>(AuthStatus.uninitialized);
  ValueNotifier<AuthStatus> get statusNotifier => _statusNotifier;

  final AuthService _authService;
  UserModel?    _user;
  AuthStatus    _status = AuthStatus.uninitialized;

  String? _verificationId;
  int?    _resendToken;
  bool   _isResendEnabled = false;
  int    _resendCountdown  = 60;
  Timer? _resendTimer;
  String? _phoneForVerification;

  bool get canResend => _isResendEnabled;

  int get countdown => _resendCountdown;
  AuthProvider(this._authService) {
    _init();
  }

  UserModel? get user            => _user;
  AuthStatus get status          => _status;
  bool       get isAuthenticated => _status == AuthStatus.authenticated;
  void _setStatus(AuthStatus status) {
    if (_status != status){
      _status = status;
      _statusNotifier.value = status;
      // notifyListeners(); // optional, for internal rebuilds only
    }else{

    }
  }

  Future<void> _init() async {
    try {
      _user   = await _authService.getCurrentUser();
      _setStatus(AuthStatus.authenticated);
      print("got the user data in provider");
    } catch (e) {
      print ("i can not load user data $e");
      _setStatus(AuthStatus.unauthenticated);
      // _status = AuthStatus.unauthenticated;
    }
    // notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    // _status = ;
    _setStatus(AuthStatus.authenticating);
    // notifyListeners();

    try {
      _user   = await _authService.signInWithEmail(email: email, password: password);
      _setStatus(AuthStatus.authenticated);

      _status = AuthStatus.authenticated;
    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      _status = AuthStatus.unauthenticated;
      rethrow;
    }

    // notifyListeners();
  }

  Future<void> signUpWithEmail( String email, String password) async {
    _setStatus(AuthStatus.authenticating);
    // _status = AuthStatus.authenticating;
    // notifyListeners();
    try {
      _user   = await _authService.signUpWithEmail( email: email, password: password);
      _setStatus(AuthStatus.authenticated);
      _status = AuthStatus.authenticated;
    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      _status = AuthStatus.unauthenticated;
      rethrow;
    }

    // notifyListeners();
  }

  Future<void> signInAnonymously() async {
    _status = AuthStatus.authenticating;
    _setStatus(AuthStatus.authenticating);

    notifyListeners();

    try {
      _user   = await _authService.signInAnonymously();
      _status = AuthStatus.authenticated;
      _setStatus(AuthStatus.authenticated);

    } catch (e) {
      _setStatus(AuthStatus.unauthenticated);
      _status = AuthStatus.unauthenticated;
      rethrow;
    }

    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _status = AuthStatus.authenticating;
    notifyListeners();
    _setStatus(AuthStatus.authenticating);

    try {
      _user   = await _authService.signInWithGoogle();
      _setStatus(AuthStatus.authenticated);
      _status = AuthStatus.authenticated;
      print ("done user registered");
    } catch (e) {
      print ("nope user is not registered $e");
      _setStatus(AuthStatus.unauthenticated);
      _status = AuthStatus.unauthenticated;
      rethrow;
    }

    notifyListeners();
  }

  Future<void> startPhoneVerification(String phone) async {
    // _status = AuthStatus.authenticating;
    // _setStatus(AuthStatus.authenticating);
    _phoneForVerification = phone;
    _isResendEnabled = false;
    _resendCountdown = 60;
    _resendTimer?.cancel();
    _setStatus(AuthStatus.codeSent);
    // notifyListeners();
    await _authService.verifyPhoneNumber(
      phone: phone,
      forceResendingToken: _resendToken,
      timeout: const Duration(seconds: 60),

      // عند التحقق التلقائي (Android)
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ربط وتسجيل الدخول
        try {
          final model = await _authService.signInWithPhone(
            phone: phone,
            verificationId: credential.verificationId ?? '',
            smsCode: credential.smsCode ?? '',
          );
          _user   = model;
          _status = AuthStatus.authenticated;
          _setStatus(AuthStatus.authenticated);
        } catch (e) {
          _status = AuthStatus.unauthenticated;
          _setStatus(AuthStatus.unauthenticated);
        }
        notifyListeners();
      },

      // عند فشل التحقق
      verificationFailed: (FirebaseAuthException e) {
        _status = AuthStatus.unauthenticated;
        _setStatus(AuthStatus.unauthenticated);
        // notifyListeners();
      },

      // عند إرسال الكود بنجاح
      codeSent: (String verId, int? token) {
        _verificationId = verId;
        _resendToken    = token;
        _status         = AuthStatus.codeSent;
        _setStatus(AuthStatus.codeSent);
        _startResendTimer();
        notifyListeners();
      },


      // عند انتهاء مهلة الاسترداد التلقائي
      codeAutoRetrievalTimeout: (String verId) {
        _verificationId = verId;
        _isResendEnabled = true;
        notifyListeners();
      },
    );
  }
  Future<void> submitSmsCode(String smsCode) async {
    if (_verificationId == null || _phoneForVerification == null) {
      throw Exception('No verification in progress.');
    }
    // _status = AuthStatus.authenticating;
    // notifyListeners();
    _setStatus(AuthStatus.authenticating);

    try {
      _user   = await _authService.signInWithPhone(
        phone: _phoneForVerification!,
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      // _status = AuthStatus.authenticated;
      _setStatus(AuthStatus.authenticated);
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _setStatus(AuthStatus.unauthenticated);
      print ("isssue can not auth $e");
      rethrow;
    }

    notifyListeners();
  }

  Future<void> resendCode() async {
    if (!_isResendEnabled || _phoneForVerification == null) return;
    await startPhoneVerification(_phoneForVerification!);
  }
  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendCountdown = 60;
    _isResendEnabled = false;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendCountdown--;
      if (_status == AuthStatus.authenticated){
        timer.cancel();
      }
      else if (_resendCountdown <= 0 ) {
        _isResendEnabled = true;
        timer.cancel();
        _status = AuthStatus.codeSent;
        _setStatus(AuthStatus.codeSent);
        notifyListeners();
      }
      //
    });
  }



  Future<void> signInWithPhone({
    required String verificationId,
    required String smsCode,
    required String phone,
  })
  async {
    // _status = AuthStatus.authenticating;
    // notifyListeners();

    try {
      _user   = await _authService.signInWithPhone(
        verificationId: verificationId,
        smsCode:        smsCode,
        phone: phone
      );
      _status = AuthStatus.authenticated;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      rethrow;
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    _setStatus(AuthStatus.unauthenticated);
    await _authService.signOut();
    _user   = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();

   await clearHive();
    final pref=  await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }

  Future<void> updateInterests(List<String> interests) async {
    if (_user == null) return;
    await _authService.updateUserInterests(_user!.uid, interests);
    _user = _user!.copyWith(interests: interests);
    notifyListeners();
  }

  Future<void> updateThemeMode(String newMode) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', newMode);
    await _authService.updateUserSettings(
        uid: _user!.uid, themeMode: newMode);
    _user = _user!.copyWith(themeMode: newMode);
    notifyListeners();
  }

  /// 2) Language
  Future<void> updateLanguage(String newLang) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLang);
    await _authService.updateUserSettings(
        uid: _user!.uid, language: newLang);
    _user = _user!.copyWith(language: newLang);
    notifyListeners();
  }

  /// 3) Master notifications toggle
  Future<void> updateNotificationsEnabled(bool on) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', on);
    await _authService.updateUserSettings(
        uid: _user!.uid, notificationsEnabled: on);
    _user = _user!.copyWith(notificationsEnabled: on);
    notifyListeners();
  }

  /// 4) Debts reminder
  Future<void> updateDebtsReminder(bool on) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_debts', on);
    await _authService.updateUserSettings(
        uid: _user!.uid, debtsReminder: on);
    _user = _user!.copyWith(debtsReminder: on);
    notifyListeners();
  }

  /// 5) Daily reminder
  Future<void> updateDailyReminder(bool on) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminder_daily', on);
    await _authService.updateUserSettings(
        uid: _user!.uid, dailyReminder: on);
    _user = _user!.copyWith(dailyReminder: on);
    notifyListeners();
  }

  /// 6) News & updates
  Future<void> updateNewsUpdates(bool on) async {
    if (_user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('news_updates', on);
    await _authService.updateUserSettings(
        uid: _user!.uid, newsUpdates: on);
    _user = _user!.copyWith(newsUpdates: on);
    notifyListeners();
  }


  Future<void> updateProfile(String name, String phone)async{
      if (_user == null) return;
      // call service to enforce uniqueness & write
      await _authService.updateUserProfile(
        uid: _user!.uid,
        name: name,
        phone: phone,
      );
      // pull back fresh copy
      _user = await _authService.getCurrentUser();
      notifyListeners();
  }
}
