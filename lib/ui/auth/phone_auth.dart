// lib/ui/auth/phone_auth_screen.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../generated/l10n.dart';
import '../../state/auth_provider.dart';
import '../../state/intersets_provider.dart';
import '../../theme/theme_consts.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  String? _phone;
  String? _smsCode;
  final _smsController = TextEditingController();

  @override
  void dispose() {
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t        = S.of(context);
    final theme    = Theme.of(context);
    final colors   = theme.colorScheme;
    final size     = MediaQuery.of(context).size;
    final formWidth = size.width * 0.85;

    final authProv  = context.watch<AuthProvider>();
    final status    = authProv.status;
    final isLoading = status == AuthStatus.authenticating;
    final codeSent  = status == AuthStatus.codeSent;

    return Scaffold(
      body: Stack(
        children: [
          // Background side images
          Positioned(
            right: -30,
            top: 180,
            width: size.width * 0.4,
            height: 100,
            child: Image.asset(
              'assets/abstract.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: -30,
            bottom: 60,
            height: 100,
            width: size.width * 0.4,
            child: Image.asset(
              'assets/abstract.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceL),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.12),

                // Welcome text
                Text(
                  t.loginWelcome,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: colors.onSurface),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppConstants.spaceXL),

                // Blurred overlay form
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Phone input (only when code not sent)
                            if (!codeSent) ...[
                              IntlPhoneField(
                                initialCountryCode: 'SA',
                                decoration: InputDecoration(
                                  labelText: t.phoneHint,
                                  hintText: t.phoneHint,
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (phone) {
                                  setState(() => _phone = phone.completeNumber);
                                },
                              ),
                              const SizedBox(height: AppConstants.spaceM),
                              ElevatedButton(
                                onPressed: (_phone == null || isLoading)
                                    ? null
                                    : () {
                                  authProv.startPhoneVerification(_phone!);
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppConstants.radiusM,
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                                    : Text(t.sendCode),
                              ),
                            ],

                            // OTP input & verify (after codeSent)
                            if (codeSent) ...[
                              PinCodeTextField(
                                appContext: context,
                                length: 6,
                                controller: _smsController,
                                keyboardType: TextInputType.number,
                                autoFocus: true,
                                onChanged: (val) {
                                  setState(() => _smsCode = val);
                                },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(8),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: colors.surface,
                                  inactiveFillColor: colors.surfaceVariant.withOpacity(0.5),
                                  selectedFillColor: colors.surface,
                                  inactiveColor: colors.outline,
                                  selectedColor: colors.primary,
                                  activeColor: colors.primary,
                                ),
                                animationType: AnimationType.fade,
                                animationDuration: const Duration(milliseconds: 200),
                              ),
                              const SizedBox(height: AppConstants.spaceM),
                              ElevatedButton(
                                onPressed: (_smsCode?.length == 6 && !isLoading)
                                    ? () async{
                                  await authProv.submitSmsCode(_smsCode!);
                                  if (authProv.user != null){
                                    String id = authProv.user!.uid;
                                    List<String> intersest = authProv.user!.interests;
                                    await context.read<InterestProvider>().updateInterests(intersest, id);
                                  }

                                  context.go('/');
                                }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppConstants.radiusM,
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                                    : Text(t.verify),
                              ),
                              const SizedBox(height: AppConstants.spaceM),

                              // Resend & countdown
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!authProv.canResend) ...[
                                    Text(
                                      t.resendIn.toString()
                                          .replaceFirst('{seconds}', authProv.countdown.toString()),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ] else ...[
                                    TextButton(
                                      onPressed: authProv.resendCode,
                                      child: Text(t.resendCode),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
