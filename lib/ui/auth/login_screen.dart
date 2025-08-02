// lib/ui/auth/login_email_screen.dart

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../generated/l10n.dart';
import '../../state/auth_provider.dart';
import '../../state/intersets_provider.dart';
import '../../theme/theme_consts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading  = false;

  Future<void> _login() async {
    if (_passwordController.text.trim().length<6 || _emailController.text.trim().isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
          content: Text("email is required && password should be atleast 6 digits"),
        backgroundColor: Colors.redAccent,
      ));
      return ;
    }
    setState(() => _isLoading = true);
    try {
      final authPro  = context.read<AuthProvider>();
      await authPro.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (authPro.user != null){
        String id = authPro.user!.uid;
        List<String> intersest = authPro.user!.interests;
        await context.read<InterestProvider>().updateInterests(intersest, id);

      }
      context.go('/');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
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
    final formWidth = size.width * 0.90;

    return Scaffold(
      body: Stack(
        children: [
          // 1) Background images
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
              repeat: ImageRepeat.noRepeat,
            ),
          ),

          // 2) Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceL),
            child: Column(
              children: [
                // Spacer
                SizedBox(height: size.height * 0.12),

                // Login title (behind the blur overlay)
                Text(
                  t.loginWelcome,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(color: colors.onBackground),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppConstants.spaceXL),

                // 3) Blurred overlay container
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
                          children: <Widget>[
                            // Email field
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: t.loginWithEmail,
                                hintText: t.loginWithEmail,
                              ),
                            ),
                            const SizedBox(height: AppConstants.spaceM),

                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (e){
                                if (e==null || e.isEmpty) return "should be atelast 6 digits";
                                if (e.length<6) return "should be atelast 6 digits";
                                return null ;
                              },
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: t.passwordHint,
                                hintText: t.passwordHint,
                                suffixIcon: Icon(Icons.visibility_off),
                              ),
                            ),
                            const SizedBox(height: AppConstants.spaceS),

                            // Remember & Forgot row
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                  activeColor: colors.primary,
                                ),
                                Text(t.rememberMe),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Navigate to Forgot Password flow
                                  },
                                  child: Text(t.forgotPassword),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spaceM),

                            // Login button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppConstants.radiusM,
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : Text(t.login),
                            ),

                            const SizedBox(height: AppConstants.spaceM),

                            // Or separator
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(t.or),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spaceM),

                            // Google & Phone buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [

                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: Padding(padding: EdgeInsets.all(8), child: FaIcon(FontAwesomeIcons.google, color: Colors.red),),
                                    label: Text(t.loginWithGoogle),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: AppConstants.radiusM),
                                    ),
                                    onPressed: () async {
                                      try {
                                        final authPro = context.read<AuthProvider>();
                                        await authPro.signInWithGoogle();
                                        print ("no logging the user via google is over");
                                        if (authPro.user != null){
                                          // String id = authPro.user!.uid;
                                          // List<String> intersest = authPro.user!.interests;
                                          // await context.read<InterestProvider>().updateInterests(intersest, id);
                                          print ("now updating the interest in provider is over");
                                        }
                                        context.go('/');
                                      } catch (e) {
                                        print ("the error is $e");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text(e.toString())));
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spaceS),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: Padding(padding: EdgeInsets.all(8), child: Icon(Icons.phone, color: colors.onSurface)),
                                    label: Text(t.loginWithPhone),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: AppConstants.radiusM),
                                    ),
                                    onPressed: () => context.push('/login/phone'),
                                  ),
                                ),
                              ],
                            ),

                            // 4) Apple button (iOS only)
                            if (Platform.isIOS) ...[
                              const SizedBox(height: AppConstants.spaceM),
                              OutlinedButton.icon(
                                icon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                                ),
                                label: Text(t.loginWithApple),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: AppConstants.radiusM),
                                ),
                                onPressed: () async {
                                  try {
                                    // TODO: implement Apple sign-in
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(content: Text(e.toString())));
                                  }
                                },
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
