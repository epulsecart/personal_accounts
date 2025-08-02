// lib/services/category_service_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../data/user_module/categories.dart';
import 'category_service.dart';

class CategoryServiceImpl implements CategoryService {
  static const _boxName        = 'categories';
  static const _kLastPulledKey = 'cats_lastPulledAt';

  final Box<CategoryModel> _box;
  final FirebaseFirestore    _firestore;
  final String               _userId;
  final SharedPreferences    _prefs;

  CategoryServiceImpl({
    required String userId,
    FirebaseFirestore? firestore,
    required SharedPreferences prefs,
  })  : _userId     = userId,
        _box         = Hive.box<CategoryModel>(_boxName),
        _firestore   = firestore ?? FirebaseFirestore.instance,
        _prefs       = prefs;

  // ─── 1) Seeding & Initial sync ───────────────────────────────────────────

  @override
  Future<void> seedDefaults() async {
    if (_box.isNotEmpty) return;
    final uuid = const Uuid();
    final defaults = <CategoryModel>[
      CategoryModel(
        id: uuid.v4(), name: 'Food',      iconName: 'fastfood',
        colorValue: 0xFFE57373, isExpense: true,
      ),
      CategoryModel(
        id: uuid.v4(), name: 'Transport', iconName: 'directions_car',
        colorValue: 0xFF64B5F6, isExpense: true,
      ),
      CategoryModel(
        id: uuid.v4(), name: 'Shopping',  iconName: 'shopping_cart',
        colorValue: 0xFFBA68C8, isExpense: true,
      ),
      CategoryModel(
        id: uuid.v4(), name: 'Salary',    iconName: 'attach_money',
        colorValue: 0xFF81C784, isExpense: false,
      ),
      CategoryModel(
        id: uuid.v4(), name: 'Other',     iconName: 'category',
        colorValue: 0xFF90A4AE, isExpense: true,
      ),
    ];
    for (var cat in defaults) {
      await _box.put(cat.id, cat);
    }
  }

  @override
  Future<void> initialSeed() async {
    if (_box.isNotEmpty) return;
    final snap = await _firestore
        .collection('users/$_userId/categories')
        .orderBy('name')
        .get();
    for (var doc in snap.docs) {
      final cat = CategoryModel.fromFirestore(doc);
      await _box.put(cat.id, cat);
    }
    await _prefs.setString(_kLastPulledKey, DateTime.now().toIso8601String());
  }

  // ─── 2) Local reads ───────────────────────────────────────────────────────

  @override
  Future<List<CategoryModel>> fetchAll() async {
    return _box.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Stream<List<CategoryModel>> watchAll() {
    return _box.watch()
        .map((_) => _box.values.toList()..sort((a, b) => a.name.compareTo(b.name)))
        .startWith(_box.values.toList()..sort((a, b) => a.name.compareTo(b.name)));
  }

  @override
  Future<CategoryModel?> getById(String id) async {
    return _box.get(id);
  }

  @override
  Future<List<CategoryModel>> fetchExpenses() async {
    return fetchAll().then((list) => list.where((c) => c.isExpense).toList());
  }

  @override
  Future<List<CategoryModel>> fetchIncome() async {
    return fetchAll().then((list) => list.where((c) => !c.isExpense).toList());
  }

  // ─── 3) Search ────────────────────────────────────────────────────────────

  @override
  Future<List<CategoryModel>> searchByName(String query) async {
    final q = query.toLowerCase();
    return (await fetchAll())
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
  }

  // ─── 4) CRUD with immediate Firestore writes ─────────────────────────────

  @override
  Future<void> addCategory(CategoryModel cat) async {
    await _box.put(cat.id, cat);
    await _firestore
        .collection('users/$_userId/categories')
        .doc(cat.id)
        .set(cat.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> updateCategory(CategoryModel cat) async {
    await _box.put(cat.id, cat);
    await _firestore
        .collection('users/$_userId/categories')
        .doc(cat.id)
        .set(cat.toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
    await _firestore
        .collection('users/$_userId/categories')
        .doc(id)
        .delete();
  }

  // ─── 5) Downstream sync ───────────────────────────────────────────────────

  @override
  Future<void> syncDownstream() async {
    final last = DateTime.tryParse(
        _prefs.getString(_kLastPulledKey) ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
    final snap = await _firestore
        .collection('users/$_userId/categories')
        .where('updatedAt', isGreaterThan: last)
        .orderBy('updatedAt')
        .get();
    for (var doc in snap.docs) {
      final cat = CategoryModel.fromFirestore(doc);
      await _box.put(cat.id, cat);
    }
    await _prefs.setString(_kLastPulledKey, DateTime.now().toIso8601String());
  }

  @override
  Future<void> synchronize() => syncDownstream();

  // ─── 6) Utility ──────────────────────────────────────────────────────────

  @override
  Future<void> clearAll() async {
    await _box.clear();
    await _prefs.remove(_kLastPulledKey);
  }
}
