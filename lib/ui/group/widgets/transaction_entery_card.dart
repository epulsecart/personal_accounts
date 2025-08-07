import 'package:accounts/data/groups_module/group_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../state/auth_provider.dart';
import '../../../generated/l10n.dart';
import '../../../state/group_module/group_transaction_provider.dart';
import '../../../state/group_module/group_txn_change_request_provider.dart';
import '../../../theme/theme_consts.dart';
import 'edit_group_transaction_sheet.dart';

class TransactionEntryCard extends StatelessWidget {
  final GroupTransactionModel txn;
  final AuthProvider authProvider ;
  const TransactionEntryCard({super.key, required this.txn, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final user = context.read<AuthProvider>().user!;
    final isMePayer = txn.fromUserId == user.uid;
    final isMeReceiver = txn.toUserId == user.uid;

    final nameLine = isMePayer
        ? 'You → ${txn.receiverName}'
        : isMeReceiver
        ? '${txn.payerName} → You'
        : '${txn.payerName} → ${txn.receiverName}';

    final statusBadge = txn.isApproved
        ? _StatusBadge(label: t.approved, color: Colors.green)
        : _StatusBadge(label: t.pending, color: Colors.orange);

    return GestureDetector(
      onTap: (){
        context.read<GroupTxnChangeRequestProvider>().synchronize();
        showEditGroupTransactionSheet(context,txn , context.read<GroupTxnChangeRequestProvider>(), authProvider);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM, vertical: 6),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Who paid who
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nameLine,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${txn.amount.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (txn.description.isNotEmpty)
                Text(
                  txn.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),

              const SizedBox(height: 8),

              // Status + actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  statusBadge,
                  Row(
                    children: [
                      // Approve button
                      if (!txn.isApproved && isMeReceiver)
                        TextButton.icon(
                          icon: const Icon(Icons.check_circle),
                          label: Text(t.approve),
                          onPressed: () async{
                            final provider = context.read<GroupTransactionProvider>();
                            await provider.approveTransaction(txn.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(t.transactionApproved)),
                            );
                          },
                        ),

                      // Edit button
                      if (isMePayer && txn.isApproved)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // TODO: open edit dialog
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppConstants.radiusM,
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
