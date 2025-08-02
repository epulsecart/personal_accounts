// lib/ui/personal/transactions_list_view.dart

import 'package:accounts/data/user_module/categories.dart';
import 'package:accounts/helpers/icon_look_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';
import '../../state/user_module/category_provider.dart';
import '../../state/user_module/transactions_provider.dart';
import '../../theme/theme_consts.dart';
import 'edit_category.dart';
import 'edit_transaction.dart';

class TransactionsListView extends StatefulWidget {
  String? search;
   TransactionsListView({Key? key, this.search}) : super(key: key);

  @override
  State<TransactionsListView> createState() => _TransactionsListViewState();
}

class _TransactionsListViewState extends State<TransactionsListView> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    // watch categories and transactions from their providers
    final categories = context.watch<CategoryProvider>().categories;
    final allTxns   = context.watch<TransactionProvider>().transactions;

    // apply single‐select filter
    var txns = _selectedCategoryId == null
        ? allTxns
        : allTxns.where((tx) => tx.categoryId == _selectedCategoryId).toList();


    if (widget.search!=null && widget.search!.isNotEmpty){
      txns = txns.where((tx)=> tx.description.contains(widget.search!)).toList();
    }

    return Column(
      children: [
        // 1) Category chips
        SizedBox(
          height: 56,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppConstants.spaceS),
            itemBuilder: (context, i) {
              final cat = categories[i];
              final selected = cat.id == _selectedCategoryId;
              return AnimatedContainer(
                duration: AppConstants.mediumDuration,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM),
                decoration: BoxDecoration(
                  color: selected ? colors.primary : colors.surfaceVariant,
                  borderRadius: AppConstants.radiusM,
                ),
                child: InkWell(
                  borderRadius: AppConstants.radiusM,
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedCategoryId = null;
                      } else {
                        _selectedCategoryId = cat.id;
                      }
                    });
                  },
                  onDoubleTap: (){
                    final currentList =
                    allTxns.where((tx) => tx.categoryId == cat.id).toList();
                    showDialog(
                      context: context,
                      builder: (_) => EditCategoryDialog(category: cat, hasTransactions: currentList.isNotEmpty,),
                      barrierDismissible: true,
                    );
                  },
                  onLongPress: (){
                    final currentList =
                    allTxns.where((tx) => tx.categoryId == cat.id).toList();
                    showDialog(
                      context: context,
                      builder: (_) => EditCategoryDialog(category: cat, hasTransactions: currentList.isNotEmpty,),
                      barrierDismissible: true,
                    );
                  },
                  child: Row(
                    children: [
                      // try FontAwesome, fallback if invalid
                      Builder(builder: (_) {
                        try {
                          return FaIcon(
                            iconLookup[cat.iconName],
                            // IconDataSolid(_iconDataFromString(cat.iconName)),
                            size: 20,
                            color: selected ? colors.onPrimary : colors.onSurface,
                          );
                        } catch (_) {
                          return Icon(
                            Icons.category,
                            size: 20,
                            color: selected ? colors.onPrimary : colors.onSurface,
                          );
                        }
                      }),
                      const SizedBox(width: 8),
                      Text(
                        cat.name,
                        style: text.bodyMedium?.copyWith(
                          color: selected ? colors.onPrimary : colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppConstants.spaceM),

        // 2) Transactions list or empty message
        Expanded(
          child: txns.isEmpty
              ? Center(
            child: Text(
              t.noTransactions,
              style: text.bodyLarge,
              textAlign: TextAlign.center,
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceS),
            itemCount: txns.length,
            separatorBuilder: (_, __) => Divider(
              color: colors.outline,
              height: 1,
              indent: AppConstants.spaceM,
              endIndent: AppConstants.spaceM,
            ),
            itemBuilder: (context, idx) {
              final tx = txns[idx];
              final amountColor =
              tx.isExpense ? colors.error : colors.primary;
              final prefix = tx.isExpense ? '-' : '+';
              final formattedAmount = NumberFormat.currency(
                symbol: '',
                decimalDigits: 2,
              ).format(tx.amount);

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spaceM),
                leading: Builder(builder: (_) {
                  // show category icon on the left
                  final cat = categories
                      .firstWhere(
                          (c) => c.id == tx.categoryId,
                      orElse: () => categories.isNotEmpty
                          ? categories.first
                          : CategoryModel(id: '', name: '', iconName: '', colorValue: 0, isExpense: false));
                  if (cat.id == '') {
                    return const Icon(Icons.category);
                  }
                  try {
                    return FaIcon(
                      iconLookup[cat.iconName],
                      color: Color(cat.colorValue),
                    );
                  } catch (_) {
                    return Icon(
                      Icons.category,
                      color: Color(cat.colorValue),
                    );
                  }
                }),
                title: Text(
                  tx.description,
                  style: text.bodyLarge,
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(tx.date),
                  style: text.bodySmall,
                ),
                trailing: Text(
                  '$prefix$formattedAmount',
                  style: text.bodyMedium?.copyWith(color: amountColor),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => EditTransactionSheet(txn: tx),
                  );
                  // optional: navigate to detail/edit
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Helper to map a FontAwesome icon name string to its codePoint.
  /// You can expand this mapping or use a lookup table.
  int _iconDataFromString(String name) {
    switch (name) {
      case 'coffee':
        return FontAwesomeIcons.coffee.codePoint;
      case 'shopping-cart':
        return FontAwesomeIcons.shoppingCart.codePoint;
    // add more mappings as needed...
      default:
        throw Exception('Unknown icon: $name');
    }
  }
}
