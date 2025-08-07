// lib/ui/widgets/dashboard_header.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../theme/theme_consts.dart';

class DashboardHeader extends StatelessWidget {
  final double spent;
  final double income;
  final String searchText;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSettingsTap;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback getExcel;

  const DashboardHeader({
    required this.spent,
    required this.income,
    required this.searchText,
    required this.onSearchChanged,
    required this.onSettingsTap,
    required this.controller,
    required this.focusNode,
    required this.getExcel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t      = S.of(context);
    final theme  = Theme.of(context);
    final colors = theme.colorScheme;

    // Currency formatter
    final locale = Localizations.localeOf(context).toString();
    String fmt(double v) => NumberFormat.currency(locale: locale, symbol: '').format(v);

    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 163,
      pinned: false,
      floating: false,
      snap: false,
      elevation: 0,
      automaticallyImplyLeading: false,

      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spaceM,
              vertical: AppConstants.spaceS,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1) Settings + Search
                Row(
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.cog, color: colors.secondary),
                      onPressed: onSettingsTap,
                    ),
                    const SizedBox(width: AppConstants.spaceS),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        onChanged: (v) {
                          onSearchChanged(v);
                        },
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: colors.onBackground),
                        decoration: InputDecoration(
                          hintText: t.searchHint,
                          prefixIcon: Icon(Icons.search, color: colors.onSurface),
                          suffixIcon: (controller.text.isNotEmpty || focusNode.hasFocus)
                              ? IconButton(
                            icon: Icon(Icons.close, color: colors.onSurface),
                            onPressed: () {
                              controller.clear();
                              onSearchChanged('');
                            },
                          )
                              : null,
                          filled: true,
                          fillColor: colors.surfaceVariant.withOpacity(0.3),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spaceM,
                            vertical: AppConstants.spaceS,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spaceM),

                // 2) Glass‐morphic spent/income summary
                GestureDetector(
                  onTap: (){
                    getExcel();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.spaceM),
                        decoration: BoxDecoration(
                          color: colors.surface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colors.outline.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _SummaryItem(
                                  icon: Icons.arrow_upward,
                                  iconColor: colors.error,
                                  label: t.spentThisMonth,
                                  amount: fmt(spent),
                                ),
                                _SummaryItem(
                                  icon: Icons.arrow_downward,
                                  iconColor: colors.primary,
                                  label: t.incomeThisMonth,
                                  amount: fmt(income),
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Text(S.of(context).getexcel, style: TextStyle(fontSize: 12),),
                            //     SizedBox(width: 10,),
                            //     Icon(Icons.download)
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String amount;
  const _SummaryItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final colors = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(amount,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: colors.onBackground, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: colors.onBackground.withOpacity(0.7))),
          ],
        ),
      ],
    );
  }
}
