
import 'package:accounts/data/groups_module/group_model.dart';
import 'package:accounts/state/group_module/group_provider.dart';
import 'package:accounts/ui/group/tabs/join_requests_tab.dart';
import 'package:accounts/ui/group/tabs/members_tab_view.dart';
import 'package:accounts/ui/group/tabs/summary_tab_view.dart';
import 'package:accounts/ui/group/tabs/transactions_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

class GroupDetailScreen extends StatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

   List<Widget> _tabs =   [
     Tab(text: 'transactions'),
     Tab(text: 'members'),
     Tab(text: 'joinCode'),
     Tab(text: 'summary'),
   ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      _tabs = [
        Tab(text: S.of(context).transactions),
        Tab(text: S.of(context).members),
        Tab(text: S.of(context).joinCode),
        Tab(text: S.of(context).summary),
      ];
      setState(() {

      });
    });
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final groupsProvider = context.watch<GroupProvider>();
    final GroupModel currentGroup  = groupsProvider.groups.firstWhere((g)=> g.id == widget.groupId) ;
    return Scaffold(
      appBar: AppBar(
        title: Text(currentGroup.name),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:  [
          TransactionsTabView(group:currentGroup ),
          MembersTabView(group: currentGroup),
          JoinRequestsTabView(group: currentGroup,),
          SummaryTabView(groupId: currentGroup.id,groupName: currentGroup.name),
        ],
      ),
    );
  }
}
