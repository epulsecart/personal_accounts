import '../../data/user_module/templates.dart';

abstract class TemplateService {
  /// 1) Initial pull from Firestore if Hive is empty
  Future<void> initialSeed();

  /// 2) Local reads (Hive only)
  Future<List<TemplateModel>> fetchAll();
  Stream<List<TemplateModel>> watchAll();
  Future<TemplateModel?> getById(String id);

  /// 3) CRUD (local + immediate Firestore write)
  Future<void> addTemplate(TemplateModel tpl);
  Future<void> updateTemplate(TemplateModel tpl);
  Future<void> deleteTemplate(String id);

  /// 4) “Due” helpers
  /// Returns templates with nextRun <= now AND autoAdd == true
  Future<List<TemplateModel>> fetchDueTemplates({DateTime? now});
  /// Advances tpl.nextRun according to its frequency
  Future<void> bumpNextRun(TemplateModel tpl);

  /// 5) Sync downstream only
  Future<void> syncDownstream();
  Future<void> synchronize();

  /// 6) Clear everything locally (and reset pull marker)
  Future<void> clearAll();
}
