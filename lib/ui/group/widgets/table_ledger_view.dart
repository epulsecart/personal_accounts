// lib/ui/groups_module/table_ledger_view.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../state/auth_provider.dart';
import '../../../state/group_module/group_transaction_provider.dart';


class TableLedgerView extends StatelessWidget {
  final String groupId;

  const TableLedgerView({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final txns = context.watch<GroupTransactionProvider>().transactions;
    final myId = context.read<AuthProvider>().user!.uid;
    final theme = Theme.of(context);

    if (txns.isEmpty) {
      return Center(
        child: Text(t.noTransactionsYet, style: theme.textTheme.bodyLarge),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        headingRowColor: MaterialStateProperty.all(theme.colorScheme.surfaceVariant),
        columns: [
          DataColumn(label: Text(t.date)),
          DataColumn(label: Text(t.description)),
          DataColumn(label: Text(t.amount)),
          DataColumn(label: Text(t.fromTo)),
          DataColumn(label: Text(t.status)),
        ],
        rows: txns.map((txn) {
          final isMine = txn.fromUserId == myId;
          final amount = (isMine ? '-' : '+') + txn.amount.toStringAsFixed(2);
          final statusColor = txn.isApproved
              ? Colors.green
              : theme.colorScheme.tertiary;

          return DataRow(
            cells: [
              DataCell(Text(DateFormat.yMd().format(txn.date))),
              DataCell(
                Tooltip(
                  message: txn.description,
                  child: Text(
                    txn.description.length > 20
                        ? txn.description.substring(0, 20) + '...'
                        : txn.description,
                  ),
                ),
              ),
              DataCell(Text(
                amount,
                style: TextStyle(
                  color: isMine ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )),
              DataCell(Text('${txn.payerName} → ${txn.receiverName}')), // You can replace with names if available
              DataCell(Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  txn.isApproved ? t.approved : t.pending,
                  style: TextStyle(color: statusColor, fontSize: 12),
                ),
              )),
            ],
            onSelectChanged: (_) {
              final isReceiver = txn.toUserId == myId;
              final isSender = txn.fromUserId == myId;
              if (isReceiver && !txn.isApproved) {
                _showApproveDialog(context, txn.id);
              } else if (isSender) {
                // _openEditSheet(context, txn);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  void _showApproveDialog(BuildContext context, String txnId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).approveTransaction),
        content: Text(S.of(context).confirmApproveTransaction),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(S.of(context).approve),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = context.read<GroupTransactionProvider>();
      await provider.approveTransaction(txnId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).transactionApproved)),
      );
    }
  }

}
