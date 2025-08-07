// lib/ui/group/group_transaction/edit_group_transaction_sheet.dart

import 'dart:ui';

import 'package:accounts/data/groups_module/group_transaction_model.dart';
import 'package:accounts/data/groups_module/group_txn_change_request_model.dart';
import 'package:accounts/state/auth_provider.dart';
import 'package:accounts/state/group_module/group_txn_change_request_provider.dart';
import 'package:accounts/theme/theme_consts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../generated/l10n.dart';

Future<void> showEditGroupTransactionSheet(
    BuildContext context,
    GroupTransactionModel txn,
    GroupTxnChangeRequestProvider txnChangeProvider,
    AuthProvider authProvider
    ) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditGroupTransactionSheet(txn: txn, authProvider: authProvider, txnChangeProvider: txnChangeProvider,),
  );
}

class EditGroupTransactionSheet extends StatefulWidget {
  final GroupTransactionModel txn;
  final GroupTxnChangeRequestProvider txnChangeProvider ;
  final AuthProvider authProvider ;
  const EditGroupTransactionSheet({super.key, required this.txn, required this.authProvider, required this.txnChangeProvider});

  @override
  State<EditGroupTransactionSheet> createState() =>
      _EditGroupTransactionSheetState();
}

class _EditGroupTransactionSheetState extends State<EditGroupTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _descCtrl;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController(text: widget.txn.amount.toString());
    _descCtrl = TextEditingController(text: widget.txn.description);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitChange() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = widget.txnChangeProvider;
    final auth = widget.authProvider;

    final newAmount = double.tryParse(_amountCtrl.text.trim());
    final newDesc = _descCtrl.text.trim();

    final req = GroupTxnChangeRequestModel(
      id: Uuid().v4(),
      groupId: widget.txn.groupId,
      transactionId: widget.txn.id,
      type: ChangeType.update,
      requestedBy: auth.user!.uid,
      oldAmount: widget.txn.amount,
      newAmount: newAmount,
      oldDescription: widget.txn.description,
      newDescription: newDesc,
      status: RequestStatus.pending,
      requestedAt: DateTime.now(),
    );

    await provider.requestChange(req);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(S.of(context).changeRequestSentForApproval)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final provider = widget.txnChangeProvider;
    final myUid = widget.authProvider.user!.uid;
    final pending = provider.requests.any((r) =>
    r.transactionId == widget.txn.id &&
        r.requestedBy == myUid &&
        r.status == RequestStatus.pending);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: BackdropFilter(

        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollCtl) {
            return Container(
              // height: MediaQuery.of(context).size.height * .5,
              padding: EdgeInsets.only(
                left: AppConstants.spaceM,
                right: AppConstants.spaceM,
                top: AppConstants.spaceM,
                bottom: bottomInset + AppConstants.spaceM,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollCtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.editTransaction, style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppConstants.spaceM),

                    if (pending)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.spaceM),
                        child: Row(
                          children:  [
                            Icon(Icons.info_outline, color: Colors.orange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(t.alreadyHaveAPendingRequest),
                            ),
                          ],
                        ),
                      ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            decoration:  InputDecoration(labelText: t.amount),
                            enabled: !pending,
                            validator: (v) {
                              if (v == null || v.isEmpty) return t.fieldRequired;
                              if (double.tryParse(v) == null) return t.invalidNumber;
                              return null;
                            },
                          ),
                          const SizedBox(height: AppConstants.spaceM),
                          TextFormField(
                            controller: _descCtrl,
                            decoration:  InputDecoration(labelText: t.description),
                            enabled: !pending,
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? t.fieldRequired : null,
                          ),
                          const SizedBox(height: AppConstants.spaceM),
                          if (!pending)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _submitChange,
                                icon: const Icon(Icons.sync_alt),
                                label:  Text(t.requestChange),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceM * 2),

                    Text(t.changeHistory, style: theme.textTheme.titleMedium),
                    const SizedBox(height: AppConstants.spaceS),
                    ...provider.requests
                        .where((r) => r.transactionId == widget.txn.id)
                        .map((r) => ListTile(
                      title: Text(
                          "${t.amount}: ${r.oldAmount} → ${r.newAmount}"),
                      subtitle: Text(
                          "${t.description}: ${r.oldDescription} → ${r.newDescription ?? '-'}"),
                      trailing: (r.requestedBy != myUid && r.status == RequestStatus.pending)?
                      !isProcessing?
                      SizedBox(
                        width: MediaQuery.of(context).size.width *.3,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: ()async {
                                setState(() {
                                  isProcessing = true;
                                });
                                await provider.approveChange(requestId: r.id, approverId: myUid);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).requestApproved)));
                                context.pop();
                                isProcessing  = false;
                              },
                              child: SizedBox(
                                width:MediaQuery.of(context).size.width *.15 ,
                                child: Row(
                                  children: [
                                    Icon(Icons.check, color:Colors.green ,),
                                    Text(S.of(context).approve, style: TextStyle(color: Colors.green),)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: ()async {
                                setState(() {
                                  isProcessing = true;
                                });
                                await provider.rejectChange(requestId: r.id, approverId: myUid);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).requestRejected)));

                                isProcessing = false;

                                context.pop();
                              },
                              child: SizedBox(
                                width:MediaQuery.of(context).size.width *.15 ,
                                child: Row(
                                  children: [
                                    Icon(Icons.cancel, color:Colors.red ,),
                                    Text(S.of(context).reject, style: TextStyle(color: Colors.red),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):
                          SizedBox.shrink(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ):
                      Text(
                        r.status.name.toUpperCase(),
                        style: TextStyle(
                          color: r.status == RequestStatus.approved
                              ? Colors.green
                              : r.status == RequestStatus.rejected
                              ? Colors.red
                              : Colors.orange,
                        ),
                      )
                    )),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
