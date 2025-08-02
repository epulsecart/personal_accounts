// lib/services/template_service_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/user_module/templates.dart';
import 'template_service.dart';

class TemplateServiceImpl implements TemplateService {
  static const _boxName        = 'templates';
  static const _kLastPulledKey = 'tpls_lastPulledAt';

  final Box<TemplateModel> _box;
  final FirebaseFirestore   _firestore;
  final String              _userId;
  final SharedPreferences   _prefs;

  TemplateServiceImpl({
    required String userId,
    FirebaseFirestore? firestore,
    required SharedPreferences prefs,
  })  : _userId    = userId,
        _box       = Hive.box<TemplateModel>(_boxName),
        _firestore =
            firestore ?? FirebaseFirestore.instance,
        _prefs     = prefs;

  /// 1) Pull all remote templates into Hive if empty
  @override
  Future<void> initialSeed() async {
    if (_box.isNotEmpty) return;
    final snap = await _firestore
        .collection('users/$_userId/templates')
        .orderBy('nextRun')
        .get();
    for (var doc in snap.docs) {
      final data = doc.data();
      final tpl = TemplateModel(
        id: doc.id,
        title: data['title'] as String,
        amount: (data['amount'] as num).toDouble(),
        description: data['description'] as String?,
        categoryId: data['categoryId'] as String?,
        frequency:
        Frequency.values[data['frequency'] as int],
        nextRun:
        (data['nextRun'] as Timestamp).toDate(),
        autoAdd: data['autoAdd'] as bool,
      );
      await _box.put(tpl.id, tpl);
    }
    await _prefs.setString(
        _kLastPulledKey,
        DateTime.now().toIso8601String());
  }

  /// 2) Local reads
  @override
  Future<List<TemplateModel>> fetchAll() async {
    final list = _box.values.toList();
    list.sort((a, b) => a.nextRun.compareTo(b.nextRun));
    return list;
  }

  @override
  Stream<List<TemplateModel>> watchAll() {
    return _box.watch()
        .map((_) => _box.values
        .toList()
      ..sort(
            (a, b) => a.nextRun.compareTo(b.nextRun),
      ))
        .startWith(_box.values
        .toList()
      ..sort(
            (a, b) => a.nextRun.compareTo(b.nextRun),
      ));
  }

  @override
  Future<TemplateModel?> getById(String id) async {
    return _box.get(id);
  }

  /// 3) CRUD w/ immediate Firestore writes
  @override
  Future<void> addTemplate(TemplateModel tpl) async {
    await _box.put(tpl.id, tpl);
    await _firestore
        .collection('users/$_userId/templates')
        .doc(tpl.id)
        .set(_toFirestoreMap(tpl), SetOptions(merge: true));
  }

  @override
  Future<void> updateTemplate(TemplateModel tpl) async {
    await _box.put(tpl.id, tpl);
    await _firestore
        .collection('users/$_userId/templates')
        .doc(tpl.id)
        .set(_toFirestoreMap(tpl), SetOptions(merge: true));
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await _box.delete(id);
    await _firestore
        .collection('users/$_userId/templates')
        .doc(id)
        .delete();
  }

  /// 4) Due‐template helpers
  @override
  Future<List<TemplateModel>> fetchDueTemplates({
    DateTime? now,
  }) async {
    final t = now ?? DateTime.now();
    return _box.values
        .where((tpl) =>
    tpl.autoAdd && !tpl.nextRun.isAfter(t))
        .toList();
  }

  @override
  Future<void> bumpNextRun(TemplateModel tpl) async {
    final current = tpl.nextRun;
    DateTime next;
    switch (tpl.frequency) {
      case Frequency.daily:
        next = current.add(const Duration(days: 1));
        break;
      case Frequency.weekly:
        next = current.add(const Duration(days: 7));
        break;
      case Frequency.monthly:
        final y = current.year + (current.month == 12 ? 1 : 0);
        final m = (current.month % 12) + 1;
        final d = current.day;
        // roll to last valid day if needed
        final lastDay = DateTime(y, m + 1, 0).day;
        next = DateTime(
          y,
          m,
          d <= lastDay ? d : lastDay,
          current.hour,
          current.minute,
          current.second,
        );
        break;
      case Frequency.custom:
        next = current; // manual edit required later
        break;
    }
    final updated = TemplateModel(
      id: tpl.id,
      title: tpl.title,
      amount: tpl.amount,
      description: tpl.description,
      categoryId: tpl.categoryId,
      frequency: tpl.frequency,
      nextRun: next,
      autoAdd: tpl.autoAdd,
    );
    // persist locally + remote
    await _box.put(updated.id, updated);
    await _firestore
        .collection('users/$_userId/templates')
        .doc(updated.id)
        .set(_toFirestoreMap(updated), SetOptions(merge: true));
  }

  /// 5) Downstream‐only sync
  @override
  Future<void> syncDownstream() async {
    final last = DateTime.tryParse(
        _prefs.getString(_kLastPulledKey) ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final snap = await _firestore
        .collection('users/$_userId/templates')
        .where('updatedAt', isGreaterThan: last)
        .orderBy('updatedAt')
        .get();
    for (var doc in snap.docs) {
      final data = doc.data();
      final tpl  = TemplateModel(
        id: doc.id,
        title: data['title'] as String,
        amount: (data['amount'] as num).toDouble(),
        description: data['description'] as String?,
        categoryId: data['categoryId'] as String?,
        frequency:
        Frequency.values[data['frequency'] as int],
        nextRun:
        (data['nextRun'] as Timestamp).toDate(),
        autoAdd: data['autoAdd'] as bool,
      );
      await _box.put(tpl.id, tpl);
    }
    await _prefs.setString(
        _kLastPulledKey,
        DateTime.now().toIso8601String());
  }

  @override
  Future<void> synchronize() => syncDownstream();

  /// 6) Utility
  @override
  Future<void> clearAll() async {
    await _box.clear();
    await _prefs.remove(_kLastPulledKey);
  }

  // ─── Helpers ────────────────────────────────────────────────────────────

  Map<String, dynamic> _toFirestoreMap(TemplateModel tpl) {
    return {
      'title': tpl.title,
      'amount': tpl.amount,
      'description': tpl.description,
      'categoryId': tpl.categoryId,
      'frequency': tpl.frequency.index,
      'nextRun': Timestamp.fromDate(tpl.nextRun),
      'autoAdd': tpl.autoAdd,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
