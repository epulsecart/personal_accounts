import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../data/groups_module/group_join_request_model.dart';
import '../data/groups_module/group_model.dart';
import '../data/groups_module/group_transaction_model.dart';
import '../data/groups_module/group_txn_change_request_model.dart';
import '../data/groups_module/settlement_request_model.dart';
import '../data/offline_mutation.dart';
import '../data/user_module/categories.dart';
import '../data/user_module/sync_record.dart';
import '../data/user_module/templates.dart';
import '../data/user_module/transactions.dart';

Future<void> initializeHive() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);

    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(TemplateModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(SyncOperationAdapter());
    Hive.registerAdapter(SyncRecordAdapter());
    Hive.registerAdapter(FrequencyAdapter());
    /// offline mutations
    Hive.registerAdapter(MutationOpAdapter());          // typeId: 100
    Hive.registerAdapter(OfflineMutationAdapter());     // typeId: 101


    /// groups boxes
    Hive
      ..registerAdapter(GroupModelAdapter())                   // typeId:20
      ..registerAdapter(GroupTransactionModelAdapter())        // typeId:21
      ..registerAdapter(JoinStatusAdapter())                   // typeId:22
      ..registerAdapter(GroupJoinRequestModelAdapter())        // typeId:23
      ..registerAdapter(ChangeTypeAdapter())                   // typeId:24
      ..registerAdapter(RequestStatusAdapter())                // typeId:25
      ..registerAdapter(GroupTxnChangeRequestModelAdapter())   // typeId:26
      ..registerAdapter(SettlementRequestModelAdapter());      // typeId:27



    // 3) Open all your boxes:
    await Hive.openBox<CategoryModel>('categories');
    await Hive.openBox<TemplateModel>('templates');
    await Hive.openBox<TransactionModel>('transactions');
    await Hive.openBox<SyncRecord>('sync_queue');

    /// offline mutation
    await Hive.openBox<OfflineMutation>('mutation_queue');


    /// groups boxex
  // groups
  await Hive.openBox<GroupModel>('groups');
  await Hive.openBox<GroupTransactionModel>('group_transactions');
  await Hive.openBox<GroupJoinRequestModel>('group_join_requests');
  await Hive.openBox<GroupTxnChangeRequestModel>('group_txn_changes');
  await Hive.openBox<SettlementRequestModel>('settlement_requests');;



  }catch(e){
    print ("can not register hive $e");

  }
  // TODO: Register Hive adapters here
  // Hive.registerAdapter(UserModelAdapter());
}
Future<void> clearHive ()async{
 try {
   await Hive.box<TransactionModel>('transactions').clear();
   await Hive.box<SyncRecord>('sync_queue').clear();
   await Hive.box<CategoryModel>('categories').clear();
   await Hive.box<TemplateModel>('templates').clear();
   await Hive.box<OfflineMutation>('mutation_queue').clear();
   await Hive.box<GroupModel>('groups').clear();
   await Hive.box<GroupTransactionModel>('group_transactions').clear();
   await Hive.box<GroupJoinRequestModel>('group_join_requests').clear();
   await Hive.box<GroupTxnChangeRequestModel>('group_txn_changes').clear();
   await Hive.box<SettlementRequestModel>('settlement_requests').clear();
 }catch(e){
   print ("can not clear hive $e");
 }
}