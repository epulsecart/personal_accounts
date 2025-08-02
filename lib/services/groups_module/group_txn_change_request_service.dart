// lib/services/groups_module/group_txn_change_request_service.dart

import 'package:accounts/data/groups_module/group_txn_change_request_model.dart';

/// Manages “change requests” for a single group transaction:
/// - requestChange, approveChange, rejectChange
/// - purely local reads & watch
/// - one-time seed and two-way sync to Firestore sub-collection
abstract class GroupTxnChangeRequestService {
  /// Create a new update/delete request.
  Future<void> requestChange(GroupTxnChangeRequestModel req);

  /// Mark an existing request approved.
  Future<void> approveChange({
    required String requestId,
    required String approverId,
  });

  /// Mark an existing request rejected.
  Future<void> rejectChange({
    required String requestId,
    required String approverId,
    String? reason,
  });

  /// One-off load from Firestore (if box empty).
  Future<void> initialSeed();

  /// Push all local mutations (via `OfflineMutation`) upstream.
  Future<void> syncUpstream();

  /// Pull all remote documents into Hive (overwrites/merges local).
  Future<void> syncDownstream();

  /// Convenience: run upstream then downstream.
  Future<void> synchronize();

  /// Fetch current list from Hive, sorted by request time desc.
  Future<List<GroupTxnChangeRequestModel>> fetchAll();

  /// Stream Hive changes live.
  Stream<List<GroupTxnChangeRequestModel>> watchAll();

  /// For testing/reset: clear Hive box (but leave queue intact).
  Future<void> clearLocal();
}
