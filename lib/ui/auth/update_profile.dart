// lib/ui/auth/update_profile_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../generated/l10n.dart';
import '../../state/auth_provider.dart';
import '../../theme/theme_consts.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  String? _phone;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _nameController = TextEditingController();
    _nameController.text = (context.read<AuthProvider>().user?.name??null)??'';
    _phone= context.read<AuthProvider>().user?.phone??null;
    // _nameController
    super.initState();
  }
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _phone == null) return;
    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().updateProfile(
        _nameController.text.trim(),
        _phone!.trim(),
      );
      // on success, AuthProvider.user is refreshed,
      // your GroupsModule will rebuild automatically
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t      = S.of(context);
    final theme  = Theme.of(context);
    final colors = theme.colorScheme;
    final size   = MediaQuery.of(context).size;
    final formWidth = size.width * 0.9;

    return Scaffold(
      body: Stack(children: [
        // 1) Decorative background blobs
        Positioned(
          right: -30, top: 180,
          width: size.width * 0.4, height: 100,
          child: Image.asset('assets/abstract.png', fit: BoxFit.cover),
        ),
        Positioned(
          left: -30, bottom: 60,
          width: size.width * 0.4, height: 100,
          child: Image.asset('assets/abstract.png', fit: BoxFit.cover),
        ),

        // 2) Content
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceL),
          child: Column(children: [
            SizedBox(height: size.height * 0.12),

            // 2a) Explanation text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceM),
              child: Text(
                t.updateProfilePrompt,  // e.g. "To use Groups & Projects…"
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: colors.onBackground),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppConstants.spaceXL),

            // 2b) Blurred form
            Center(
              child: ClipRRect(
                borderRadius: AppConstants.radiusL,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: formWidth,
                    padding: const EdgeInsets.all(AppConstants.spaceL),
                    decoration: BoxDecoration(
                      color: colors.surface.withOpacity(0.4),
                      borderRadius: AppConstants.radiusL,
                      border: Border.all(
                        color: colors.outline.withOpacity(0.6),
                        width: 1.2,
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Name field
                          TextFormField(
                            controller: _nameController,
                            // initialValue: context.read<AuthProvider>().user?.name??null,
                            decoration: InputDecoration(
                              labelText: t.fullName,
                              hintText: t.fullNameHint,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return t.nameRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppConstants.spaceM),

                          // Phone field
                          IntlPhoneField(
                            initialCountryCode: 'SA',
                            decoration: InputDecoration(
                              labelText: t.phoneHint,
                              hintText: t.phoneHint,
                            ),
                            initialValue: context.read<AuthProvider>().user?.phone??null,
                            onChanged: (phone) {
                              _phone = phone.completeNumber;
                            },
                            validator: (p) {
                              if (p == null || p.number.trim().isEmpty) {
                                return t.phoneRequired;
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppConstants.spaceM),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppConstants.radiusM,
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 24, width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : Text(t.updateProfile),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.1),
          ]),
        ),
      ]),
    );
  }
}
