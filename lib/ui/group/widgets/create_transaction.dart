// lib/ui/groups_module/add_transaction_sheet.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../data/groups_module/group_transaction_model.dart';
import '../../../generated/l10n.dart';
import '../../../state/auth_provider.dart';
import '../../../state/group_module/group_transaction_provider.dart';
import '../../../theme/theme_consts.dart';


class AddGroupTransactionSheet extends StatefulWidget {
  final List<Map<String, String>> members;
  final String groupId;
  final GroupTransactionProvider txnProvider;
  const AddGroupTransactionSheet({super.key, required this.members, required this.groupId, required this.txnProvider});

  @override
  State<AddGroupTransactionSheet> createState() => _AddGroupTransactionSheetState();
}

class _AddGroupTransactionSheetState extends State<AddGroupTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _descCtrl   = TextEditingController();
  bool _isProcessing = false;
  String? _fromId;
  String? _toId;

  @override
  void initState() {
    super.initState();
    final me = context.read<AuthProvider>().user!;
    _fromId = me.uid;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate() || _fromId == null || _toId == null || _fromId == _toId) return;
    setState(() => _isProcessing = true);
    try {
      final me = context.read<AuthProvider>().user!;
      String payerName = '';
      String receiverName = '';
      try {
        payerName = widget.members.firstWhere((m)=>m.keys.first == _fromId)[_fromId]??'';
        receiverName = widget.members.firstWhere((m)=>m.keys.first == _toId)[_toId]??'';
      }catch(e){

      }
      final provider = widget.txnProvider;
      final txn = GroupTransactionModel(
        id: const Uuid().v4(),
        groupId: widget.groupId,
        fromUserId: _fromId!,
        toUserId: _toId!,
        amount: double.parse(_amountCtrl.text),
        description: _descCtrl.text.trim(),
        date: DateTime.now(),
        isApproved: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(), createdBy: me.uid, isDeleted: false, payerName: payerName, receiverName: receiverName,
      );
      await provider.addTransaction(txn);
      if (mounted) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).transactionCreated)));
    } catch (e) {
      print("issue in making new transaction $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
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
                color: theme.colorScheme.surface.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollCtl,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.newTransaction, style: theme.textTheme.titleLarge),
                      const SizedBox(height: AppConstants.spaceM),

                      TextFormField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: t.amountHint),
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.fieldRequired;
                          if (double.tryParse(v) == null) return t.invalidNumber;
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.spaceM),

                      TextFormField(
                        controller: _descCtrl,
                        decoration: InputDecoration(labelText: t.descriptionHint),
                        validator: (v) => v == null || v.trim().isEmpty ? t.fieldRequired : null,
                      ),
                      const SizedBox(height: AppConstants.spaceM),

                      Text(t.payer, style: theme.textTheme.labelMedium),
                      Wrap(
                        spacing: AppConstants.spaceS,
                        children: widget.members.map((m) => ChoiceChip(
                          label: Text(m.values.first.toString()),
                          selected: m.keys.first == _fromId,
                          onSelected: (_) => setState(() => _fromId = m.keys.first),
                        )).toList(),
                      ),
                      const SizedBox(height: AppConstants.spaceM),

                      Text(t.receiver, style: theme.textTheme.labelMedium),
                      Wrap(
                        spacing: AppConstants.spaceS,
                        children: widget.members.map((m) => ChoiceChip(
                          label: Text(m.values.first),
                          selected: m.keys.first == _toId,
                          onSelected: (_) => setState(() => _toId = m.keys.first),
                        )).toList(),
                      ),
                      const SizedBox(height: AppConstants.spaceM),

                      if (_isProcessing)
                        const Center(child: CircularProgressIndicator())
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onSubmit,
                            child: Text(t.submit),
                          ),
                        ),
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
