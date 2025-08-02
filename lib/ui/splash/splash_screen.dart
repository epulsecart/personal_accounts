// lib/ui/splash/splash_screen.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../../state/auth_provider.dart';
import '../../theme/theme_consts.dart';

const _prefInterestKey = 'user_interests';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Set<String> _selectedModes = {};

  Future<void> _onNext() async {
    if (_selectedModes.isEmpty) return;
    final authProv = context.read<AuthProvider>();
    if (!authProv.isAuthenticated) {
      await authProv.signInAnonymously();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefInterestKey, _selectedModes.toList());
    await authProv.updateInterests(_selectedModes.toList());
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final _options = <_OptionItem>[
      _OptionItem(key: 'personal', label: t.personalTracker, icon: Icons.person),
      _OptionItem(key: 'shared',   label: t.sharing,        icon: Icons.group),
      _OptionItem(key: 'project',  label: t.project,        icon: Icons.work),
    ];
    final theme     = Theme.of(context);
    final colors    = theme.colorScheme;
    final textTheme = theme.textTheme;
    final size   = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ─── Background side-images ─────────────────────
          Positioned(
            right: -30,
            top: 180,
            width: size.width * 0.4,
            height: 100,
            child: Image.asset(
              'assets/abstract.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.3,
            ),
          ),
          Positioned(
            left: -40,
            bottom: 60,
            height: 100,
            child: Image.asset(
              'assets/abstract.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
          ),

          // ─── Blurred overlay ───────────────────────────
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: SafeArea(

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spaceM,
                      vertical: AppConstants.spaceL,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo + animation
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.radiusXL.topLeft.x),
                            ),
                            padding: const EdgeInsets.all(AppConstants.spaceM),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppConstants.radiusXL.topLeft.x),
                              child: Image.asset('assets/logo.png',
                              width: 160, height: 160,)
                              // Lottie.asset(
                              //   'assets/logo.json',
                              //   width: 160, height: 160,
                              //   repeat: false,
                              // ),
                            ),
                          ),
                        ),

                        AppConstants.vGap16,

                        // Title
                        Text(
                          t.splashTitle,
                          style: textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),

                        AppConstants.vGap16,

                        // Interest options
                        ..._options.map((opt) {
                          final selected = _selectedModes.contains(opt.key);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppConstants.spaceS),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: AppConstants.radiusM,
                                side: BorderSide(
                                  color: selected ? colors.primary : colors.outline,
                                  width: 1.5,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: colors.primary,
                                checkColor: colors.onPrimary,
                                title: Text(opt.label, style: textTheme.bodyLarge),
                                secondary: Icon(opt.icon, color: colors.onSurface),
                                value: selected,
                                onChanged: (v) => setState(() {
                                  if (v == true) _selectedModes.add(opt.key);
                                  else          _selectedModes.remove(opt.key);
                                }),
                              ),
                            ),
                          );
                        }).toList(),

                        AppConstants.vGap16,

                        // Next button
                        ElevatedButton(
                          onPressed: _selectedModes.isEmpty ? null : _onNext,
                          child: Text(t.next),
                        ),

                        AppConstants.vGap16,

                        // Already have account
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(t.alreadyHaveAccount),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── Foreground content ─────────────────────────

        ],
      ),
    );
  }
}

class _OptionItem {
  final String   key;
  final String   label;
  final IconData icon;
  const _OptionItem({
    required this.key,
    required this.label,
    required this.icon,
  });
}
