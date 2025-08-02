// lib/ui/widgets/dashboard_tab_bar.dart

import 'package:flutter/material.dart';

import '../../theme/theme_consts.dart';

class DashboardTabBar extends SliverPersistentHeaderDelegate {
  final TabController controller;
  final List<Widget> tabs;

  DashboardTabBar({ required this.controller, required this.tabs });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: Colors.transparent, // so it floats over your page
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spaceM, vertical: AppConstants.spaceS),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TabBar(
          controller: controller,
          indicator: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          labelColor: colors.onPrimary,
          unselectedLabelColor: colors.onBackground,
          labelStyle: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
          unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w400),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: -30, vertical: 4),
          labelPadding: const EdgeInsets.symmetric(horizontal: 0),
          tabs: tabs,
        ),
      ),
    );
  }

  @override
  double get maxExtent => kToolbarHeight + AppConstants.spaceS * 2;
  @override
  double get minExtent => maxExtent;
  @override
  bool shouldRebuild(covariant DashboardTabBar old) =>
      old.controller != controller || old.tabs != tabs;
}
