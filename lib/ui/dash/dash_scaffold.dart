import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../generated/l10n.dart';
import '../../state/intersets_provider.dart';
import '../group /home.dart';
import '../personal/home.dart';
import '../projects/home.dart';


class DashboardScaffold extends StatefulWidget {
  const DashboardScaffold({Key? key}) : super(key: key);

  @override
  State<DashboardScaffold> createState() => _DashboardScaffoldState();
}

class _DashboardScaffoldState extends State<DashboardScaffold> {
  int _currentIndex = 0;

  final _allTabs = <_TabItem>[
    _TabItem('personal', label: (t) => t.personalTab,   icon: FontAwesomeIcons.user),
    _TabItem('shared',   label: (t) => t.groupsTab,     icon: FontAwesomeIcons.users),
    _TabItem('project',  label: (t) => t.projectsTab,   icon: FontAwesomeIcons.briefcase),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<InterestProvider>().loadInterests();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final t         = S.of(context);
    final interests = context.watch<InterestProvider>().interests;

    // Filter to only tabs the user selected
    final availableTabs = _allTabs.where((tab) => interests.contains(tab.key)).toList();

    // Keep index in bounds
    if (_currentIndex >= availableTabs.length) {
      _currentIndex = 0;
    }

    // Map each key to its module widget
    final pageMap = <String, Widget>{
      'personal': const PersonalModuleView(),
      'shared':   const GroupsModule(),
      'project':  const ProjectsModule(),
    };

    return availableTabs.length>= 2?Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: availableTabs.map((tab) => pageMap[tab.key]!).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: availableTabs.map((tab) {
          return BottomNavigationBarItem(
            icon: FaIcon(tab.icon),
            label: tab.label(t),
          );
        }).toList(),
      ),
    )
        : availableTabs.length==1 ? pageMap[availableTabs.first.key]?? Container(): Scaffold(
      body: CircularProgressIndicator(),
    );
  }
}

class _TabItem {
  final String key;
  final String Function(S t) label;
  final IconData icon;
  const _TabItem(this.key, {required this.label, required this.icon});
}
