// lib/state/transaction_provider.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';

import '../../data/user_module/transactions.dart';
import '../../services/user_module/transactions_service.dart';


/// Exposes all transaction data + sync operations to the UI.

enum ReportType { expense, income, net }
class CategoryBarData {
  final String categoryId;
  final double percentage; // 0.0 – 1.0
  final double netValue;   // positive for income, negative for expense (net mode)

  CategoryBarData({
    required this.categoryId,
    required this.percentage,
    required this.netValue,
  });
}

extension on TransactionModel {
  bool get isIncome => !isExpense;
}

class TransactionProvider extends ChangeNotifier {
  final TransactionService _service;

  TransactionProvider(this._service) {
    _initialize();
  }

  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  String? _error;
  String? get error => _error;

  Summary _summary = Summary(totalExpense: 0, totalIncome: 0);
  Summary get summary => _summary;


  late final StreamSubscription<List<TransactionModel>> _sub;

  /// 1) Initial load: seed, sync, then listen to changes.
  Future<void> _initialize() async {
    _setLoading(true);
    try {
      await _service.initialSeed();
      _summary = await _service.getSummary();

      // Subscribe to Hive box changes:
      _sub = _service.watchAll().listen((list) {
        _transactions = list;
        notifyListeners();
      });
      // One‐off sync upstream/downstream:
      await synchronize();
    } catch (e) {
      _setError(e);
    } finally {
      _setLoading(false);
    }
  }


  Future<void> downloadExcel(Map data)async{
    try{
      if (data.isEmpty) return;
      final excel = Excel.createExcel();
      final headers = <String>{};
      headers.addAll({'التاريخ', 'المبلغ', 'البيان', 'التصنيف'});
      final headerList = headers.toList();
      final sheet = excel[data['date']];
      // header row
      sheet.appendRow(headerList.map((h) => TextCellValue(h)).toList());
      for (var data in data['data']) {
        final row = <TextCellValue>[];
        row.add(TextCellValue(data['date'].toString()));
        row.add(TextCellValue(data['amount'].toString()));
        row.add(TextCellValue(data['desc']));
        row.add(TextCellValue(data['category']));
        sheet.appendRow(row);
      }

      final bytes = excel.encode();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/assignments_export.xlsx')
        ..writeAsBytesSync(bytes!);
      await OpenFilex.open(file.path);

      // await file.open();
    }
    catch(e){
      print ("in provider $e");
    }
  }

  /// 2) Add / Update / Delete transactions
  Future<void> addTransaction(TransactionModel txn) async {
    await _runProcessing(() async {
      await _service.addTransaction(txn);
      await _service.syncUpstream();
      _summary = await _service.getSummary();
      notifyListeners();


    });
  }

  Future<void> updateTransaction(TransactionModel txn) async {
    await _runProcessing(() async {
      await _service.updateTransaction(txn);
      await _service.syncUpstream();
      _summary = await _service.getSummary();
      notifyListeners();

    });
  }

  Future<void> deleteTransaction(String id) async {
    await _runProcessing(() async {
      await _service.deleteTransaction(id);
      await _service.syncUpstream();
      _summary = await _service.getSummary();
      notifyListeners();

    });
  }

  /// 3) Manual sync if you need to refresh
  Future<void> synchronize() async {
    _setSyncing(true);
    try {
      await _service.syncUpstream();
      await _service.syncDownstream();
    } catch (e) {
      _setError(e);
    } finally {
      _setSyncing(false);
    }
  }

  /// 4) Local‐only queries (for search, reports, etc.)
  Future<List<TransactionModel>> search(String query) async {
    try {
      return await _service.searchByDescription(query);
    } catch (e) {
      _setError(e);
      return [];
    }
  }

  Future<List<String>> recentDescriptions({int limit = 10}) async {
    try {
      return await _service.recentDescriptions(limit: limit);
    } catch (e) {
      _setError(e);
      return [];
    }
  }

  Future<List<TransactionModel>> fetchByDateRange(DateTime start, DateTime end) async {
    try {
      return await _service.fetchByDateRange(start: start, end: end);
    } catch (e) {
      _setError(e);
      return [];
    }
  }

  Future<Summary> getSummary({DateTime? start, DateTime? end}) async {
    try {
      return await _service.getSummary(start: start, end: end);
    } catch (e) {
      _setError(e);
      return Summary(totalExpense: 0, totalIncome: 0);
    }
  }

  Future<Map<String,double>> getCategoryTotals({DateTime? start, DateTime? end}) async {
    try {
      return await _service.getCategoryTotals(start: start, end: end);
    } catch (e) {
      _setError(e);
      return {};
    }
  }

  /// 5) Utility
  Future<void> clearAll() async {
    try {
      await _service.clearAll();
      _transactions = [];
      notifyListeners();
    } catch (e) {
      _setError(e);
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  // ─── Helpers to manage booleans & errors ────────────────────────────────

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setSyncing(bool v) {
    _isSyncing = v;
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

  Future<List<CategoryBarData>> fetchReportData({
    required DateTime start,
    required DateTime end,
    required ReportType type,
  }) async {
    try {
      // 1) pull raw txns
      final txns = await fetchByDateRange(start, end);

      // 2) aggregate
      final Map<String,double> sums = {};
      for (var t in txns) {
        final v = t.amount;
        switch (type) {
          case ReportType.expense:
            if (!t.isExpense) continue;
            sums[t.categoryId ?? 'uncategorized'] = (sums[t.categoryId] ?? 0) + v;
            break;
          case ReportType.income:
            if (!t.isIncome) continue;
            sums[t.categoryId ?? 'uncategorized'] = (sums[t.categoryId] ?? 0) + v;
            break;
          case ReportType.net:
            sums[t.categoryId ?? 'uncategorized'] = (sums[t.categoryId] ?? 0) + (t.isExpense ? -v : v);
            break;
        }
      }

      // 3) compute grand‐total (use abs so both modes produce positive bar lengths)
      final grand = sums.values.fold(0.0, (acc, x) => acc + x.abs());
      if (grand == 0) return [];

      // 4) map to DTOs
      return sums.entries.map((e) {
        return CategoryBarData(
          categoryId: e.key,
          netValue:   e.value,
          percentage: e.value.abs() / grand,
        );
      }).toList();
    } catch (e) {
      _setError(e);
      return [];
    }
  }


  void _setError(Object e) {
    _error = e.toString();
    notifyListeners();
  }
}
