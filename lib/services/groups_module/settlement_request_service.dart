// lib/services/groups_module/settlement_request_service.dart

import 'package:accounts/data/groups_module/settlement_request_model.dart';

/// Manages “settlement requests” across all groups:
/// - createSettlementRequest
/// - markSettled
/// - purely local reads & watch
/// - one‐time seed and two‐way sync to Firestore
abstract class SettlementRequestService {
  /// Create a new settlement request.
  Future<void> createSettlementRequest(SettlementRequestModel req);

  /// Mark an existing request as settled.
  Future<void> markSettled({
    required String requestId,
    required DateTime settledAt,
  });

  /// One‐off load from Firestore if local box is empty.
  Future<void> initialSeed();

  /// Push any queued local mutations upstream.
  Future<void> syncUpstream();

  /// Pull all remote docs into Hive (overwrites/merges local).
  Future<void> syncDownstream();

  /// Convenience: run both upstream & downstream.
  Future<void> synchronize();

  /// Fetch current list from Hive.
  Future<List<SettlementRequestModel>> fetchAll();

  /// Stream Hive changes live.
  Stream<List<SettlementRequestModel>> watchAll();

  /// For testing/reset: clear local Hive box.
  Future<void> clearLocal();
}
