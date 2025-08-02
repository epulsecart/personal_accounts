// lib/ui/personal/edit_transaction_sheet.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../data/user_module/transactions.dart';
import '../../state/user_module/category_provider.dart';
import '../../state/user_module/transactions_provider.dart';
import '../../generated/l10n.dart';
import '../../theme/theme_consts.dart';

class EditTransactionSheet extends StatefulWidget {
  final TransactionModel txn;
  const EditTransactionSheet({Key? key, required this.txn}) : super(key: key);

  @override
  State<EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends State<EditTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountCtrl;
  late TextEditingController _descCtrl;
  String? _selectedCategoryId;
  late bool _isExpense;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(text: widget.txn.amount.toString());
    _descCtrl   = TextEditingController(text: widget.txn.description);
    _selectedCategoryId = widget.txn.categoryId;
    _isExpense  = widget.txn.isExpense;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);
    try {
      final provider = context.read<TransactionProvider>();
      final updated =
      TransactionModel(id: widget.txn.id, description: _descCtrl.text.trim(), amount: double.parse(_amountCtrl.text), date: widget.txn.date, isExpense: _isExpense, updatedAt: DateTime.now());
      await provider.updateTransaction(updated);

      Navigator.of(context).pop(); // close sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).transactionUpdated)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _onDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).confirmDeleteTitle),
        content: Text(S.of(context).confirmDeleteContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(S.of(context).yesDelete),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isProcessing = true);
    try {
      await context.read<TransactionProvider>().deleteTransaction(widget.txn.id);
      Navigator.of(context).pop(); // close sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).transactionDeleted)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t      = S.of(context);
    final theme  = Theme.of(context);
    final colors = theme.colorScheme;
    final categories = context.watch<CategoryProvider>().categories;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // tap outside to dismiss
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: DraggableScrollableSheet(
          expand: false,
          builder: (_, scrollCtl) {
            return Container(
              padding: EdgeInsets.only(
                left: AppConstants.spaceM,
                right: AppConstants.spaceM,
                top: AppConstants.spaceM,
                bottom: bottomInset + AppConstants.spaceM,
              ),
              decoration: BoxDecoration(
                color: colors.surface.withOpacity(0.9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollCtl,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(t.editTransaction,
                          style: theme.textTheme.titleLarge),
                      SizedBox(height: AppConstants.spaceM),

                      // Amount
                      TextFormField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: t.amountHint,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.fieldRequired;
                          if (double.tryParse(v) == null) return t.invalidNumber;
                          return null;
                        },
                      ),
                      SizedBox(height: AppConstants.spaceM),

                      // Description
                      TextFormField(
                        controller: _descCtrl,
                        decoration: InputDecoration(
                          labelText: t.descriptionHint,
                        ),
                        validator: (v) =>
                        v == null || v.trim().isEmpty ? t.fieldRequired : null,
                      ),
                      SizedBox(height: AppConstants.spaceM),

                      // Category chips
                      SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: AppConstants.spaceS),
                          itemBuilder: (ctx, i) {
                            final cat = categories[i];
                            final sel = cat.id == _selectedCategoryId;
                            return ChoiceChip(
                              label: Text(cat.name),
                              selected: sel,
                              onSelected: (_) {
                                setState(() => _selectedCategoryId =
                                sel ? null : cat.id);
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: AppConstants.spaceM),

                      // Expense / Income toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () =>
                                setState(() => _isExpense = false),
                            icon: Icon(Icons.arrow_downward),
                            label: Text(t.income),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_isExpense
                                  ? colors.primary
                                  : colors.surfaceVariant,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                setState(() => _isExpense = true),
                            icon: Icon(Icons.arrow_upward),
                            label: Text(t.expense),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isExpense
                                  ? colors.error
                                  : colors.surfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppConstants.spaceM),

                      // Action buttons
                      if (_isProcessing)
                        CircularProgressIndicator()
                      else ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onSave,
                            child: Text(t.saveChanges),
                          ),
                        ),
                        SizedBox(height: AppConstants.spaceS),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _onDelete,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.error),
                            ),
                            child: Text(t.deleteTransaction,
                                style: TextStyle(color: colors.error)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
