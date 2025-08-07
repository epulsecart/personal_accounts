import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/groups_module/group_model.dart';
import '../../../generated/l10n.dart';
import '../../../state/group_module/group_provider.dart';
import '../../../theme/theme_consts.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final groupProvider = context.read<GroupProvider>();

    return FutureBuilder(
      future: groupProvider.getGroupSummary(group.id),
      builder: (context, snapshot) {
        final summary = snapshot.data;
        final spent = summary?.totalExpense ?? 0;
        final income = summary?.totalIncome ?? 0;

        return GestureDetector(
          onTap: () => context.push('/groups/${group.id}'),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: AppConstants.radiusM,
            ),
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    group.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),

                  // Totals Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAmountBlock(
                        context,
                        label: t.spent,
                        amount: spent,
                        color: Colors.red,
                      ),
                      _buildAmountBlock(
                        context,
                        label: t.received,
                        amount: income,
                        color: Colors.green,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Last Updated
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${t.lastUpdated}: ${_formatDate(group.updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountBlock(BuildContext context,
      {required String label, required double amount, required Color color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Text(
          '${amount.toStringAsFixed(2)}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }
}
