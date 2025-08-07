// lib/ui/widgets/module_scaffold.dart

import 'package:flutter/material.dart';

import 'dash_header.dart';
import 'dash_tab_bar.dart';

/// A reusable module shell: SliverAppBar → TabBarView → FAB
class ModuleScaffold extends StatefulWidget {
  /// The tabs to show in the pill‐shaped TabBar
  final List<Tab> tabs;

  /// The corresponding views for each tab
  final List<Widget> tabViews;

  /// Totals to display in the AppBar summary
  final double spentAmount;
  final double incomeAmount;

  /// Callbacks
  final VoidCallback onSettingsTap;
  final String searchText;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddPressed;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final VoidCallback getExcel;


  const ModuleScaffold({
    required this.tabs,
    required this.tabViews,
    required this.spentAmount,
    required this.incomeAmount,
    required this.onSettingsTap,
    required this.searchText,
    required this.onSearchChanged,
    required this.onAddPressed,
    required this.searchController,
    required this.searchFocusNode,
    required this.getExcel,
    super.key,
  }) : assert(tabs.length == tabViews.length, 'tabs & views must match');

  @override
  State<ModuleScaffold> createState() => _ModuleScaffoldState();
}

class _ModuleScaffoldState extends State<ModuleScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar here; it's inside the CustomScrollView
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddPressed,
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          DashboardHeader(
            getExcel: widget.getExcel,
            spent: widget.spentAmount,
            income: widget.incomeAmount,
            controller: widget.searchController,
            focusNode: widget.searchFocusNode,
            searchText: widget.searchText,
            onSearchChanged: widget.onSearchChanged,
            onSettingsTap: widget.onSettingsTap,
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: DashboardTabBar(
              controller: _tabController,
              tabs: widget.tabs,
            ),
          ),

          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabViews,
            ),
          ),
        ],
      ),
    );
  }
}
