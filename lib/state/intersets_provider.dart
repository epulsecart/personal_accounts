import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

const _prefInterestKey = 'user_interests';

class InterestProvider extends ChangeNotifier {
  final AuthService _authService;

  List<String> _interests = [];
  List<String> get interests => _interests;

  InterestProvider(this._authService) {
    loadInterests();
  }

  Future<void> loadInterests() async {
    final prefs = await SharedPreferences.getInstance();

    _interests = prefs.getStringList(_prefInterestKey) ?? [];
    if (_interests.isEmpty) {
      try {
        final user = await _authService.getCurrentUser();
        if (user.interests.isNotEmpty) {
          _interests = user.interests;
          await prefs.setStringList(_prefInterestKey, _interests);
        }
      } catch (_) {
        // no-op: either not logged in yet or failure; we'll stay empty
      }
    }
    print ("interest is ${_interests.length}");
    notifyListeners();
  }

  Future<void> updateInterests(List<String> newInterests, String id) async {
    print ("i got the id it is $id , new list is ${newInterests}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefInterestKey, newInterests);
    _interests = newInterests;
    print ("_intersts is updates in provider ${interests.length}");
    await _authService.updateUserInterests(id, interests);
    notifyListeners();
  }
}
