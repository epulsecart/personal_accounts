// lib/services/groups_module/group_join_request_service.dart

import 'package:accounts/data/groups_module/group_join_request_model.dart';
import 'package:accounts/data/offline_mutation.dart';

/// Handles all local + remote CRUD & sync for “join group” requests.
abstract class GroupJoinRequestService {
  /// Create a brand‐new join request.
  Future<void> createRequest(GroupJoinRequestModel req);

  /// Mark an existing request as approved (and add member to group).
  Future<void> approveRequest(GroupJoinRequestModel req);

  /// Mark an existing request as rejected.
  Future<void> rejectRequest(GroupJoinRequestModel req);

  /// (Optionally) delete a request outright.
  Future<void> deleteRequest(String id);

  /// One‐off fetch of all requests for a given group.
  Future<List<GroupJoinRequestModel>> fetchAllForGroup(String groupId);

  /// Live stream of all requests for a given group (Hive only).
  Stream<List<GroupJoinRequestModel>> watchAllForGroup(String groupId);

  /// One‐off fetch of all requests addressed to a particular invitee.
  Future<List<GroupJoinRequestModel>> fetchAllForInvitee(String userId);

  /// Live stream of all requests addressed to a particular invitee.
  Stream<List<GroupJoinRequestModel>> watchAllForInvitee(String userId);

  /// Lookup a single request by its ID.
  Future<GroupJoinRequestModel?> getById(String id);

  /// If Hive is empty, pull _all_ join‐requests from Firestore.
  Future<void> initialSeed();

  /// Push any queued local mutations (create/update/delete) to Firestore.
  Future<void> syncUpstream();

  /// Pull remote changes (all docs) into Hive.
  Future<void> syncDownstream();

  /// Convenience: run upstream then downstream.
  Future<void> synchronize();
}
