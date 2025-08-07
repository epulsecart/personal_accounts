import 'package:accounts/ui/group/widgets/create_new_group_dialog.dart';
import 'package:accounts/ui/group/widgets/group_card.dart';
import 'package:accounts/ui/group/widgets/loading_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../state/group_module/group_provider.dart';
import '../common/error_handler.dart';

class GroupsListView extends StatefulWidget {
  final String search;
  const GroupsListView({super.key, required this.search});

  @override
  State<GroupsListView> createState() => GroupsListViewState();
}



class GroupsListViewState extends State<GroupsListView> {


  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final groupProvider = context.watch<GroupProvider>();

    if (groupProvider.isLoading) {
      return const LoadingPlaceholder(); // ⏳ Lottie shimmer
    }

    if (groupProvider.error != null) {
      return ErrorState(
        message: groupProvider.error!,
        onRetry: () => groupProvider.synchronize(),
      );
    }

    final filtered = groupProvider.groups.where((g) {
      return g.name.toLowerCase().contains(widget.search.toLowerCase());
    }).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    if (filtered.isEmpty) {
      return Center(
        child: Text(t.noGroupsFound),
      );
    }

    return RefreshIndicator(
      onRefresh: ()async{
        await context.read<GroupProvider>().synchronize();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => GroupCard(group: filtered[i]),
      ),
    );
  }
}
