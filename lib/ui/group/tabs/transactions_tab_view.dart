import 'package:accounts/data/groups_module/group_model.dart';
import 'package:accounts/state/auth_provider.dart';
import 'package:accounts/state/group_module/group_join_request_provider.dart';
import 'package:accounts/state/group_module/group_provider.dart';
import 'package:accounts/state/group_module/group_txn_change_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../state/group_module/group_transaction_provider.dart';
import '../../../theme/theme_consts.dart';
import '../widgets/create_transaction.dart';
import '../widgets/table_ledger_view.dart';
import '../widgets/timeline_ledger_view.dart';

class TransactionsTabView extends StatefulWidget {
  final GroupModel group ;
  const TransactionsTabView({super.key, required this.group});

  @override
  State<TransactionsTabView> createState() => _TransactionsTabViewState();
}

class _TransactionsTabViewState extends State<TransactionsTabView> {
  String _viewMode = 'timeline';

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final txnProvider = context.watch<GroupTransactionProvider>();
    // final groupProvider = context.watch<GroupProvider>();
    final txns = txnProvider.transactions;
    // final group  = groupProvider.groups.f

    if (txnProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }



    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => AddGroupTransactionSheet(
              groupId: widget.group.id,
              members: widget.group.memberIds,
              txnProvider: txnProvider,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      // floatingActionButton: AddGroupTransactionSheet(groupId: widget.group.id, members: widget.group.memberIds,),
      body:txns.isEmpty?   Center(child: Text(t.noTransactionsYet)): RefreshIndicator(
        onRefresh: ()async{
          await context.read<GroupTransactionProvider>().synchronize();
          await context.read<GroupJoinRequestProvider>().synchronize();
          // await context.read<GroupTxnChangeRequestProvider>().synchronize();
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spaceS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _viewMode == 'timeline'
                        ? t.timelineView
                        : t.tableView,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.view_list),
                    onSelected: (value) {
                      setState(() => _viewMode = value);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'timeline',
                        child: Text(t.timelineView),
                      ),
                      PopupMenuItem(
                        value: 'table',
                        child: Text(t.tableView),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 0),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8, // or a fixed height
              child: _viewMode == 'timeline'
                  ? TimelineLedgerView(transactions: txns, authProvider: context.read<AuthProvider>(),)
                  // : TimelineLedgerView(transactions: txns),
              : TableLedgerView(groupId: widget.group.id),
            ),
          ],
        ),
      ),
    );
  }
}
