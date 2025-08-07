// lib/services/groups/group_service_impl.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/groups_module/group_model.dart';
import '../../data/groups_module/group_transaction_model.dart';
import '../../data/offline_mutation.dart';
import '../user_module/transactions_service.dart';
import 'group_service.dart';

class GroupServiceImpl implements GroupService {
  static const _kLastPulledKey = 'groups_lastPulledAt';

  final String _userId;
  final Box<GroupModel> _groupBox;
  final Box<GroupTransactionModel> _txnBox;
  final Box<OfflineMutation> _queueBox;
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;

  GroupServiceImpl({
    required String userId,
    required Box<GroupModel> groupBox,
    required Box<GroupTransactionModel> txnBox,
    required Box<OfflineMutation> queueBox,
    SharedPreferences? prefs,
    FirebaseFirestore? firestore,
  })  : _userId      = userId,
        _groupBox    = groupBox,
        _txnBox      = txnBox,
        _queueBox    = queueBox,
        _prefs       = prefs!,
        _firestore   = firestore ?? FirebaseFirestore.instance;

  // ─── Local writes + enqueue ───────────────────────────────────────────────

  @override
  Future<void> createGroup(GroupModel group) async {
    await _groupBox.put(group.id, group);
    final m = OfflineMutation.create(
      collection: 'groups',
      docId:      group.id,
      data:       group.toMap(),
    );
    try {
      print ("tomaoe here is ${group.toMap()}");
      await _queueBox.add(m);

    }catch(e){
      print ("error puting the m in the queu box $e");
    }
  }

  @override
  Future<void> updateGroup(GroupModel group) async {
    await _groupBox.put(group.id, group);
    final m = OfflineMutation.update(
      collection: 'groups',
      docId:      group.id,
      data:       group.toMap(),
    );
    await _queueBox.add(m);
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    final currentGroup =  _groupBox.get(groupId);
    if(currentGroup!=null && currentGroup.createdBy == _userId) {
      await _groupBox.delete(groupId);
      final m = OfflineMutation.delete(
        collection: 'users/$_userId/groups',
        docId: groupId,
      );
      await _queueBox.add(m);
    }else {
      throw "can not delete group that is not created by you, ask the creator to do so";
    }
  }

  // ─── Local reads from Hive ────────────────────────────────────────────────

  @override
  List<GroupModel> fetchAllGroups()  {
    final list = _groupBox.values.toList()
      ..sort((a,b)=> a.name.compareTo(b.name));
    return list;
  }

  @override
  Stream<List<GroupModel>> watchAllGroups() {
    return _groupBox.watch()
        .map((_) => _groupBox.values.toList()..sort((a,b)=> a.name.compareTo(b.name)))
        .startWith(fetchAllGroups());
  }

  @override
  Future<GroupModel?> getGroupById(String groupId) async {
    return _groupBox.get(groupId);
  }

  // ─── Transactions in a group ──────────────────────────────────────────────

  @override
  List<GroupTransactionModel> fetchTransactions(String groupId)  {
    return _txnBox.values
        .where((t) => t.groupId == groupId)
        .toList()
      ..sort((a,b)=> b.date.compareTo(a.date));
  }

  @override
  Stream<List<GroupTransactionModel>> watchTransactions(String groupId) {
    return _txnBox.watch()
        .map((_) => _txnBox.values
        .where((t) => t.groupId == groupId)
        .toList()
      ..sort((a,b)=> b.date.compareTo(a.date)))
        .startWith( fetchTransactions(groupId));
  }

  // ─── Summary helpers ──────────────────────────────────────────────────────

  @override
  Future<Summary> getGroupSummary(String groupId) async {
    final txns = await fetchTransactions(groupId);
    double exp = 0, inc = 0;
    for (var t in txns) {
      // treat “you received” as income, “you paid” as expense
      inc += t.toUserId == _userId ? t.amount : 0;
      exp += t.fromUserId == _userId ? t.amount : 0;
    }
    return Summary(totalExpense: exp, totalIncome: inc);
  }

  @override
  Future<Map<String,double>> getMemberNetBalances(String groupId) async {
    final txns = await fetchTransactions(groupId);
    final Map<String,double> balances = {};
    for (var t in txns) {
      balances[t.toUserId]   = (balances[t.toUserId]   ?? 0) + t.amount;
      balances[t.fromUserId] = (balances[t.fromUserId] ?? 0) - t.amount;
    }
    return balances;
  }

  // ─── Sync with Firestore ──────────────────────────────────────────────────

  @override
  Future<void> syncUpstream() async {
    for (var m in _queueBox.values.toList()) {
      final ref = _firestore
          .collection(m.collection)
          .doc(m.docId);
      try {
        switch (m.operation) {
          case MutationOp.create:
          case MutationOp.update:
            await ref.set(m.data!, SetOptions(merge: true));
            break;
          case MutationOp.delete:
            await ref.delete();
            break;
        }
        await m.delete();
      } catch (e) {
        print (" iam not anle to sync$e");
        // leave in queue
      }
    }
  }

  @override
  Future<void> syncDownstream() async {
    final last = DateTime.tryParse(_prefs.getString(_kLastPulledKey) ?? '')
        ?? DateTime.fromMillisecondsSinceEpoch(0);
    print (" iwill now get down streams $last");
    print (" iwill now get down streams 1 ${DateTime.tryParse(_prefs.getString(_kLastPulledKey) ?? '')}");
    print (" iwill now get down streams 2${DateTime.fromMillisecondsSinceEpoch(0)}");
    var tempDate = DateTime.fromMillisecondsSinceEpoch(0);
    _groupBox.values.forEach((v){
      tempDate.compareTo(v.updatedAt) == -1? tempDate = v.updatedAt : tempDate = tempDate;
    });
    print ("tempDate = $tempDate");
    final snap = await _firestore
        .collection('groups')
        .where('memberUids', arrayContains: _userId)
        .where('updatedAt', isGreaterThan: tempDate)
        .orderBy('updatedAt')
        .get();
    for (var doc in snap.docs) {
      final g = GroupModel.fromFirestore(doc);
      await _groupBox.put(g.id, g);
    }
    await _prefs.setString(_kLastPulledKey, DateTime.now().toIso8601String());
  }

  @override
  Future<void> initialSeed() async {
    if (_groupBox.isNotEmpty) return;
    const batchSize = 100;
    String? lastId;
    Query q = _firestore
        .collection('groups')
        .where('memberIds', arrayContains: _userId)
        .orderBy('createdAt')
        .limit(batchSize);

    while (true) {
      if (lastId != null) {
        final lastDoc = await _firestore
            .collection('groups')
            .doc(lastId)
            .get();
        q = q.startAfterDocument(lastDoc);
      }
      final snap = await q.get();
      if (snap.docs.isEmpty) break;
      for (var doc in snap.docs) {
        final g = GroupModel.fromFirestore(doc );
        await _groupBox.put(g.id, g);
      }
      lastId = snap.docs.last.id;
      if (snap.docs.length < batchSize) break;
    }
    await _prefs.setString(_kLastPulledKey, DateTime.now().toIso8601String());
  }

  @override
  Future<void> synchronize() async {
    print ("i will now sync");
    await syncUpstream();
    await syncDownstream();
  }
}
