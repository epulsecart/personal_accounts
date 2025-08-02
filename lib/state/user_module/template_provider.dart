// lib/state/template_provider.dart

import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/user_module/templates.dart';
import '../../services/user_module/template_service.dart';


class TemplateProvider extends ChangeNotifier {
  final TemplateService _service;

  TemplateProvider(this._service) {
    _initialize();
  }

  // ─── State ────────────────────────────────────────────────────────────────

  List<TemplateModel> _templates = [];
  List<TemplateModel> get templates => _templates;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _error;
  String? get error => _error;

  late final StreamSubscription<List<TemplateModel>> _sub;

  // ─── Initialization ───────────────────────────────────────────────────────

  Future<void> _initialize() async {
    _setLoading(true);
    try {
      await _service.initialSeed();
      _sub = _service.watchAll().listen((list) {
        _templates = list;
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
    _sub.cancel();
    super.dispose();
  }

  // ─── CRUD ─────────────────────────────────────────────────────────────────

  Future<void> addTemplate(TemplateModel tpl) async {
    await _runProcessing(() => _service.addTemplate(tpl));
  }

  Future<void> updateTemplate(TemplateModel tpl) async {
    await _runProcessing(() => _service.updateTemplate(tpl));
  }

  Future<void> deleteTemplate(String id) async {
    await _runProcessing(() => _service.deleteTemplate(id));
  }

  // ─── Due & Scheduling ─────────────────────────────────────────────────────

  Future<List<TemplateModel>> fetchDueTemplates(
      {DateTime? now}) async {
    try {
      return await _service.fetchDueTemplates(now: now);
    } catch (e) {
      _setError(e);
      return [];
    }
  }

  Future<void> bumpNextRun(TemplateModel tpl) async {
    await _runProcessing(() => _service.bumpNextRun(tpl));
  }

  // ─── Sync ─────────────────────────────────────────────────────────────────

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

  Future<void> synchronize() => syncDownstream();

  // ─── Utility ───────────────────────────────────────────────────────────────

  Future<void> clearAll() async {
    await _runProcessing(() async {
      await _service.clearAll();
      _templates = [];
      notifyListeners();
    });
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  Future<void> _runProcessing(
      Future<void> Function() action) async {
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

  void _setSyncing(bool v) {
    _isSyncing = v;
    notifyListeners();
  }

  void _setError(Object e) {
    _error = e.toString();
    notifyListeners();
  }
}
