// lib/ui/transactions/add_transaction_sheet.dart

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

import '../../data/user_module/categories.dart';
import '../../data/user_module/templates.dart';
import '../../data/user_module/transactions.dart';
import '../../generated/l10n.dart';
import '../../state/user_module/category_provider.dart';
import '../../state/user_module/template_provider.dart';
import '../../state/user_module/transactions_provider.dart';

/// Call this from any widget:
///   showModalBottomSheet(
///     context: context,
///     isScrollControlled: true,
///     backgroundColor: Colors.transparent,
///     builder: (_) => AddTransactionSheet(),
///   );
class AddTransactionSheet extends StatefulWidget {
  @override
  State<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _newCatCtrl = TextEditingController();
  final _amountFocus = FocusNode();
  final _descFocus = FocusNode();

  String? _selectedCategoryId;
  bool _isExpense = true; // default
  bool _isUploadingFile = false;
  String? _uploadedFileUrl;
  XFile? _pickedFile;

  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // autofocus amount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_amountFocus);
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _newCatCtrl.dispose();
    _amountFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final choice = await showModalBottomSheet<_SourceOption>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(S.of(context).takePhoto),
              onTap: () => Navigator.pop(context, _SourceOption.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text(S.of(context).pickFromGallery),
              onTap: () => Navigator.pop(context, _SourceOption.gallery),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;

    XFile? file;
    try {
      if (choice == _SourceOption.camera) {
        file = await picker.pickImage(source: ImageSource.camera);
      } else {
        file = await picker.pickImage(source: ImageSource.gallery);
      }
      if (file == null) return;
      setState(() {
        _isUploadingFile = true;
        _pickedFile = file;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('transactions')
          .child(const Uuid().v4())
          .child(file.name);
      final task = storageRef.putFile(File(file.path));
      await task.whenComplete(() {});
      final url = await storageRef.getDownloadURL();
      if (!mounted) return;
      setState(() {
        _uploadedFileUrl = url;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).uploadFailed)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingFile = false;
        });
      }
    }
  }

  Future<void> _createNewCategory() async {
    final name = _newCatCtrl.text.trim();
    if (name.isEmpty) return;
    final catProv = context.read<CategoryProvider>();
    final id = const Uuid().v4();
    final newCat = CategoryModel(
      id: id,
      name: name,
      iconName: 'category',
      colorValue: Theme.of(context).colorScheme.primary.value,
      isExpense: _isExpense,
    );
    setState(() => _isSaving = true);
    try {
      await catProv.addCategory(newCat);
      setState(() {
        _selectedCategoryId = id;
        _newCatCtrl.clear();
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _submit({bool fromTemplate = false, TemplateModel? tpl}) async {
    setState(() {
      _error = null;
      _isSaving = true;
    });

    // build transaction model
    final id = const Uuid().v4();
    final desc = fromTemplate
        ? (tpl!.title)
        : _descCtrl.text.trim();
    final amt = fromTemplate
        ? tpl!.amount
        : double.parse(_amountCtrl.text.trim());
    final categoryId = fromTemplate
        ? tpl!.categoryId!
        : _selectedCategoryId!;
    // determine isExpense from local state
    final isExpense = _isExpense;

    final txn = TransactionModel(
      id: id,
      description: desc,
      amount: amt,
      date: DateTime.now(),
      isExpense: isExpense,
      categoryId: categoryId,
      attachment: _uploadedFileUrl, updatedAt: DateTime.now(),
    );

    try {
      final prov = context.read<TransactionProvider>();
      await prov.addTransaction(txn);
      // success feedback
      if (!mounted) return;
      //  showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (_) => Center(
      //     child: Icon(Icons.check_circle, size: 80, color: Colors.green),
      //   ),
      // );
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).transactionCreated)));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catProv = context.watch<CategoryProvider>();
    final tplProv = context.watch<TemplateProvider>();
    final locale = S.of(context);
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, ctl) => Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: ctl,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 1) Templates list
                  if (tplProv.templates.isEmpty)
                    SizedBox(
                      height: 70,
                      child: Center(child: Text(locale.noTemplatesYet)),
                    )
                  else
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tplProv.templates.length,
                        itemBuilder: (_, i) {
                          final tpl = tplProv.templates[i];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: _isUploadingFile || _isSaving
                                  ? null
                                  : () => _submit(fromTemplate: true, tpl: tpl),
                              child: Card(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(tpl.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.center),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${tpl.amount.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 16),

                  // 2 & 3) Form: amount & description
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _amountCtrl,
                        focusNode: _amountFocus,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          hintText: locale.amountHint,
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (s) =>
                        (s == null || s.isEmpty) ? locale.enterAmount : null,
                        autovalidateMode: AutovalidateMode.disabled,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocus);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descCtrl,
                        focusNode: _descFocus,
                        textInputAction: TextInputAction.done,
                        decoration:
                        InputDecoration(hintText: locale.descriptionHint),
                        validator: (s) => (s == null || s.isEmpty)
                            ? locale.enterDescription
                            : null,
                      ),
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // 4) Attach file
                  if (_pickedFile != null)
                    ListTile(
                      leading: Icon(Icons.insert_drive_file),
                      title: Text(_pickedFile!.name),
                      trailing: _isUploadingFile
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _pickedFile = null;
                            _uploadedFileUrl = null;
                          });
                        },
                      ),
                    )
                  else
                    TextButton.icon(
                      onPressed: _isUploadingFile || _isSaving
                          ? null
                          : _pickFile,
                      icon: Icon(Icons.attach_file),
                      label: Text(locale.attachFile),
                    ),

                  const SizedBox(height: 16),

                  // 5) Category selection + inline creation
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: catProv.categories
                        .where((c) => c.isExpense == _isExpense)
                        .map((c) {
                      final selected = c.id == _selectedCategoryId;
                      return ChoiceChip(
                        label: Text(c.name),
                        selected: selected,
                        onSelected: _isSaving || _isUploadingFile
                            ? null
                            : (_) {
                          setState(() {
                            _selectedCategoryId = c.id;
                          });
                        },
                      );
                    }).toList(),
                  ),
                    Text(locale.selectOrAddCategory,),
                  Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _newCatCtrl,
                        decoration: InputDecoration(
                          hintText: locale.newCategoryHint,
                          suffixIcon: IconButton(
                            icon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(locale.tapHere, style: TextStyle(fontSize: 12),),
                                Icon(Icons.add_circle, color: Colors.green),
                              ],
                            ),
                            onPressed: _isSaving || _isUploadingFile
                                ? null
                                : _createNewCategory,
                          ),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // error
                  if (_error != null)
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 16),

                  // 6) In / Out buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.arrow_upward),
                          label: Text(locale.income),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed:_formKey.currentState==null? null:  (_isSaving ||
                              _isUploadingFile ||
                              !_formKey.currentState!.validate() ||
                              _selectedCategoryId == null)
                              ? null
                              : () {
                            setState(() => _isExpense = false);
                            _submit();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.arrow_downward),
                          label: Text(locale.expense),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: _formKey.currentState==null? null: (_isSaving ||
                              _isUploadingFile ||
                              !_formKey.currentState!.validate() ||
                              _selectedCategoryId == null)
                              ? null
                              : () {
                            setState(() => _isExpense = true);
                            _submit();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _SourceOption { camera, gallery }
