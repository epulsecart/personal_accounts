import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'init_user.dart';                // your existing bootstrap helpers
import 'my_app.dart';
import 'state/theme_provider.dart';
import 'state/local_provider.dart';
import 'state/auth_provider.dart';
import 'state/intersets_provider.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This will call initializeFirebase(), initializeHive(), etc.
  final prefs       = await SharedPreferences.getInstance();
  final initialRoute = await determineStartRoute(prefs);

  // Allow dynamic font fetching:
  GoogleFonts.config.allowRuntimeFetching = true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => InterestProvider(AuthService())),
      ],
      child: MyApp(
        initialRoute: initialRoute,
        prefs: prefs,
      ),
    ),
  );
}
  