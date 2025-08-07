import 'package:accounts/ui/group/widgets/transaction_entery_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/groups_module/group_transaction_model.dart';
import '../../../data/groups_module/group_txn_change_request_model.dart';
import '../../../data/offline_mutation.dart';
import '../../../services/groups_module/group_txn_change_request_service_impl.dart';
import '../../../state/auth_provider.dart';
import '../../../state/group_module/group_txn_change_request_provider.dart';

class TimelineLedgerView extends StatelessWidget {
  final List<GroupTransactionModel> transactions;
  final AuthProvider authProvider ;
  const TimelineLedgerView({super.key, required this.transactions, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    // Group transactions by day
    final grouped = <String, List<GroupTransactionModel>>{};

    for (var txn in transactions) {
      final dayKey = _formatDate(txn.createdAt);
      grouped.putIfAbsent(dayKey, () => []).add(txn);
    }

    final dayKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Newest dates first

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: dayKeys.length,
      itemBuilder: (context, index) {
        final day = dayKeys[index];
        final dayTxns = grouped[day]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DayHeader(day),
            ...dayTxns.map((txn) =>
                ChangeNotifierProvider(
                  create: (_) => GroupTxnChangeRequestProvider(
                    GroupTxnChangeRequestServiceImpl(
                      groupId: txn.groupId,
                      txnId:  txn.id,
                      box:     Hive.box<GroupTxnChangeRequestModel>('group_txn_changes'),
                      queueBox: Hive.box<OfflineMutation>('mutation_queue'),
                    ),
                  ),
                  child: TransactionEntryCard(txn: txn, authProvider: authProvider,)),
                ),



          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);

    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat.yMMMMd().format(date); // Aug 2, 2025
  }
}

class _DayHeader extends StatelessWidget {
  final String label;

  const _DayHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
