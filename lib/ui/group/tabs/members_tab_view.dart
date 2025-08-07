import 'package:accounts/services/user_module/transactions_service.dart';
import 'package:accounts/state/group_module/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/groups_module/group_model.dart';
import '../../../generated/l10n.dart';
import '../../../state/auth_provider.dart';
import '../../../state/group_module/group_transaction_provider.dart';
import '../../../theme/theme_consts.dart';

class MembersTabView extends StatelessWidget {
  final GroupModel group;

  const MembersTabView({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final theme = Theme.of(context);
    final user = context.watch<AuthProvider>().user!;

    if (group.memberIds.isEmpty) {
      return Center(child: Text(t.noMembersFound));
    }

     var members =[];
    try {
      group.memberIds.toList().forEach((c)=> members.add({c.keys.first.toString(): c.values.first.toString()}));
      members.sort((a, b) => a.values.first.compareTo(b.values.first));
    }catch(e){
      print ("issue in sort $e");
    }
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      child: RefreshIndicator(
        onRefresh: ()async{
          await context.read<GroupTransactionProvider>().synchronize();
          await context.read<GroupProvider>().synchronize();
        },
        child: ListView(
          shrinkWrap: true,

          children: [
            Text(
              t.membersCountLabel(members.length),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppConstants.spaceM),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8, // or a fixed height
              child: ListView.separated(
                itemCount: members.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final uid = members[index].keys.first;
                  final name = members[index].values.first;
                  final isYou = uid == user.uid;
                  final isAdmin = uid == group.createdBy;

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(name.toString().characters.first),
                    ),
                    title: Text(name),
                    subtitle: Row(
                      children: [
                        if (isAdmin)
                          Text(t.memberLabelAdmin, style: theme.textTheme.labelSmall),
                        if (isAdmin && isYou) const SizedBox(width: 8),
                        if (isYou)
                          Text(t.memberLabelYou, style: theme.textTheme.labelSmall),
                      ],
                    ),
                    trailing: FutureBuilder<Summary>(
                      future: context.watch<GroupTransactionProvider>().getSummary(userId: uid),
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        final bal = snapshot.data!;
                        final bal2 = bal.totalIncome - bal.totalExpense;
                        return Text(
                          '${t.memberBalance}: ${bal2}',
                          style: TextStyle(
                            color: bal2 > 0
                                ? Colors.green
                                : bal2 < 0
                                ? Colors.red
                                : theme.textTheme.bodyMedium?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
