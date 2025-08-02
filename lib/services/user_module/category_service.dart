import '../../data/user_module/categories.dart';

abstract class CategoryService {
  /// Seed built-in defaults into Hive (once).
  Future<void> seedDefaults();

  /// If Hive is empty, fetch all remote docs into Hive.
  Future<void> initialSeed();

  /// Read all categories from Hive.
  Future<List<CategoryModel>> fetchAll();

  /// Listen to Hive changes.
  Stream<List<CategoryModel>> watchAll();

  /// Convenience lookup by ID.
  Future<CategoryModel?> getById(String id);

  /// Only expense or only income categories.
  Future<List<CategoryModel>> fetchExpenses();
  Future<List<CategoryModel>> fetchIncome();

  /// Basic CRUD: each writes Hive then Firestore.
  Future<void> addCategory(CategoryModel cat);
  Future<void> updateCategory(CategoryModel cat);
  Future<void> deleteCategory(String id);

  Future<List<CategoryModel>> searchByName(String name);

  /// Pull any updated/added remote docs since last pull.
  Future<void> syncDownstream();

  /// Convenience: just run syncDownstream().
  Future<void> synchronize();

  /// Remove everything locally (and reset pull marker).
  Future<void> clearAll();
}
