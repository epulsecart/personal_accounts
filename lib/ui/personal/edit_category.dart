// lib/ui/personal/edit_category_dialog.dart

import 'dart:ui';

import 'package:accounts/helpers/icon_look_up.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/user_module/categories.dart';
import '../../state/user_module/category_provider.dart';
import '../../generated/l10n.dart';
import '../../theme/theme_consts.dart';

class EditCategoryDialog extends StatefulWidget {
  final CategoryModel category;
  final bool hasTransactions;
  const EditCategoryDialog({Key? key, required this.category, required this.hasTransactions})
      : super(key: key);

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _nameCtrl;
  late Color _color;
  late String _iconName;

  bool _isProcessing = false;
  String? _error;

  // A curated list of FontAwesome icon names relevant to your domain:
  static const _availableIcons = <String>[
    'faCoffee',
    'faShoppingCart',
    'faCar',
    'faUtensils',
    'faHome',
    'faBriefcase',
    'faPlane',
    'faPiggyBank',
    'faHeart',
    // …add more as needed
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category.name);
    _color = Color(widget.category.colorValue);
    _iconName = widget.category.iconName;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _onApply() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = S.of(context).fieldCategoryName + ' is required');
      return;
    }
    setState(() {
      _isProcessing = true;
      _error = null;
    });
    try {
      final prov = context.read<CategoryProvider>();
      await prov.updateCategory(
        CategoryModel(id: widget.category.id, name: _nameCtrl.text.trim(), iconName: _iconName, colorValue: _color.value, isExpense: widget.category.isExpense)

      );
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _onDelete() async {
    final prov = context.read<CategoryProvider>();
    // check if any transactions exist for this category:
    final hasTxns = widget.hasTransactions;
    if (hasTxns) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).cannotDeleteCategoryWithTxns)),
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(S.of(context).deleteCategory),
        content: Text(S.of(context).confirmDeleteCategory),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(S.of(context).deleteCategory),
          ),
        ],
      ),
    );
    if (confirm == true) {
      setState(() => _isProcessing = true);
      try {
        await prov.deleteCategory(widget.category.id);
        Navigator.of(context).pop();
      } catch (e) {
        setState(() => _error = e.toString());
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      // allow tapping outside to dismiss
      onTap: () => Navigator.of(context).pop(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          backgroundColor: colors.surface.withOpacity(0.8),
          shape: RoundedRectangleBorder(borderRadius: AppConstants.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spaceM),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    t.editCategory,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppConstants.spaceM),

                  // Name field
                  TextField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: t.fieldCategoryName,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceM),

                  // Color picker
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(t.selectColor),
                  ),
                  const SizedBox(height: AppConstants.spaceS),
                  SizedBox(
                    height: 150,
                    child: BlockPicker(
                      pickerColor: _color,
                      onColorChanged: (c) => setState(() => _color = c),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceM),

                  // Icon picker
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(t.selectIcon),
                  ),
                  const SizedBox(height: AppConstants.spaceS),
                  Wrap(
                    spacing: AppConstants.spaceS,
                    runSpacing: AppConstants.spaceS,
                    children: _availableIcons.map((name) {
                      final isSelected = name == _iconName;
                      Widget iconWidget;
                      try {
                        iconWidget = FaIcon(
                          iconLookup[name],
                          size: 24,
                        );
                      } catch (_) {
                        iconWidget = Icon(Icons.category);
                      }
                      return ChoiceChip(
                        label: iconWidget,
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() => _iconName = name);
                        },
                        selectedColor: colors.primaryContainer,
                        side: BorderSide(color: isSelected ? colors.primary : colors.outline),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppConstants.spaceM),

                  // Error
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceS),
                      child: Text(_error!, style: TextStyle(color: colors.error)),
                    ),

                  // Action buttons
                  if (_isProcessing)
                    const CircularProgressIndicator()
                  else ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onApply,
                        child: Text(t.apply),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceS),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _onDelete,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.error),
                        ),
                        child: Text(t.deleteCategory, style: TextStyle(color: colors.error)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
