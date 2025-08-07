import 'dart:ui';
import 'package:accounts/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../data/groups_module/group_model.dart';
import '../../../generated/l10n.dart';
import '../../../state/group_module/group_provider.dart';
import '../../../theme/theme_consts.dart';

class CreateGroupDialog extends StatefulWidget {
  final GroupProvider groupProvider;
  const CreateGroupDialog({super.key, required this.groupProvider });

  @override
  State<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode node = FocusNode();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    node.requestFocus();
    super.initState();
  }
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final t = S.of(context);
      final provider = widget.groupProvider;
      final group = GroupModel(
        id: Uuid().v4(), // will be auto-gen by Firestore
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        createdBy: context.read<AuthProvider>().user!.uid, // filled in service
        memberIds: [{context.read<AuthProvider>().user!.uid: context.read<AuthProvider>().user?.name??''}],
        memberUids: [context.read<AuthProvider>().user!.uid],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await provider.createGroup(group);
      Navigator.of(context).pop();
    } catch (e) {
      print ("error can not create a new group $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).errorCreatingGroup)),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ClipRRect(
        borderRadius: AppConstants.radiusXL,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spaceL),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
              borderRadius: AppConstants.radiusXL,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t.createGroup,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: AppConstants.spaceM),
                  TextFormField(
                    controller: _nameCtrl,
                    focusNode: node,
                    decoration: InputDecoration(
                      labelText: t.groupName,
                    ),
                    validator: (val) =>
                    val == null || val.trim().isEmpty ? t.fieldRequired : null,
                  ),
                  const SizedBox(height: AppConstants.spaceM),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: InputDecoration(
                      labelText: t.descriptionOptional,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppConstants.spaceL),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submit,
                    icon: const Icon(Icons.check),
                    label: _isSubmitting
                        ? const CircularProgressIndicator.adaptive()
                        : Text(t.create),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
