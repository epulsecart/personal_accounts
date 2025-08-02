// lib/state/category_provider.dart

import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/user_module/categories.dart';
import '../../services/user_module/category_service.dart';


class CategoryProvider extends ChangeNotifier {
  final CategoryService _service;

  CategoryProvider(this._service) {
    _initialize();
  }

  // ─── State ────────────────────────────────────────────────────────────────

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _error;
  String? get error => _error;

  late final StreamSubscription<List<CategoryModel>> _subscription;

  // ─── Initialization: seed, initial fetch, subscribe ──────────────────────

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      // 1) Seed built-in defaults if empty
      await _service.seedDefaults();
      // 2) Pull remote into Hive if empty
      await _service.initialSeed();
      // 3) Subscribe to local Hive changes
      _subscription = _service.watchAll().listen((list) {
        _categories = list;
        notifyListeners();
      });
    } catch (e) {
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // ─── CRUD Operations ──────────────────────────────────────────────────────

  Future<void> addCategory(CategoryModel cat) async {
    await _runProcessing(() async {
      await _service.addCategory(cat);
    });
  }

  Future<void> updateCategory(CategoryModel cat) async {
    await _runProcessing(() async {
      await _service.updateCategory(cat);
    });
  }

  Future<void> deleteCategory(String id) async {
    await _runProcessing(() async {
      await _service.deleteCategory(id);
    });
  }

  // ─── Queries & Utility ─────────────────────────────────────────────────────

  /// Convenience lookup by ID.
  Future<CategoryModel?> getById(String id) async {
    try {
      return await _service.getById(id);
    } catch (e) {
      _setError(e);
      return null;
    }
  }

  /// Only expense categories.
  Future<List<CategoryModel>> fetchExpenses() async {
    try {
      return await _service.fetchExpenses();
    } catch (e) {
      _setError(e);
      return [];
    }
  }

  /// Only income categories.
  Future<List<CategoryModel>> fetchIncome() async {
    try {
      return await _service.fetchIncome();
    } catch (e) {
      _setError(e);
      return [];
    }
  }

  /// Search by name.
  Future<List<CategoryModel>> searchByName(String query) async {
    try {
      return await _service.searchByName(query);
    } catch (e) {
      _setError(e);
      return [];
    }
  }

  // ─── Sync ─────────────────────────────────────────────────────────────────

  /// Pull remote changes into local Hive.
  Future<void> syncDownstream() async {
    _setSyncing(true);
    try {
      await _service.syncDownstream();
    } catch (e) {
      _setError(e);
    } finally {
      _setSyncing(false);
    }
  }

  /// Convenience: alias for [syncDownstream].
  Future<void> synchronize() => syncDownstream();

  // ─── Reset ────────────────────────────────────────────────────────────────

  /// Clear all categories (and reset pull marker).
  Future<void> clearAll() async {
    await _runProcessing(() async {
      await _service.clearAll();
      _categories = [];
      notifyListeners();
    });
  }

  // ─── Internal helpers ─────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSyncing(bool value) {
    _isSyncing = value;
    notifyListeners();
  }

  Future<void> _runProcessing(Future<void> Function() action) async {
    _isProcessing = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      _setError(e);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void _setError(Object e) {
    _error = e.toString();
    notifyListeners();
  }
}
