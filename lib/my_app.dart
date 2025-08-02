import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'state/theme_provider.dart';
import 'state/local_provider.dart';
import 'state/auth_provider.dart';
import 'routes.dart';
import 'generated/l10n.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  final SharedPreferences prefs;

  const MyApp({
    Key? key,
    required this.initialRoute,
    required this.prefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider  = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final authProvider   = context.watch<AuthProvider>();

    // Build a new router whenever auth state changes:
    final router = AppRouter.buildRouter(
      initialRoute: initialRoute,
      authProvider: authProvider,
      prefs: prefs,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(localeProvider.locale),
      darkTheme: AppTheme.dark(localeProvider.locale),
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
