// lib/ui/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../state/auth_provider.dart';
import '../../state/theme_provider.dart';
import '../../state/local_provider.dart';
import '../../theme/theme_consts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t      = S.of(context);
    final themeP = context.watch<ThemeProvider>();
    final authP  = context.watch<AuthProvider>();
    final localeP= context.watch<LocaleProvider>();
    final user   = authP.user!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: ListView(padding: const EdgeInsets.all(AppConstants.spaceM), children: [

        // ───────── Appearance ─────────
        Text(t.appearanceSection, style: Theme.of(context).textTheme.titleMedium),
        SwitchListTile(
          title: Text(t.darkMode),
          value: themeP.themeMode == ThemeMode.dark,
          onChanged: (v) {
            themeP.toggleTheme(v);
            authP.updateThemeMode(v ? 'dark' : 'light');
          },
        ),
        const Divider(),

        // ───────── Language ─────────
        Text(t.languageSection, style: Theme.of(context).textTheme.titleMedium),
        SwitchListTile(
          title: Text(localeP.locale.languageCode == 'ar'
              ? t.languageArabic : t.languageEnglish),
          value: localeP.locale.languageCode == 'ar',
          onChanged: (v) {
            localeP.setLocale(Locale(v ? 'ar' : 'en'));
            authP.updateLanguage(v ? 'ar' : 'en');
          },
        ),
        const Divider(),

        // ───────── Notifications ─────────
        Text(t.notificationsSection, style: Theme.of(context).textTheme.titleMedium),
        SwitchListTile(
          title: Text(t.notificationsEnabled),
          value: user.notificationsEnabled,
          onChanged: authP.updateNotificationsEnabled,
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.only(left: 32),
          title: Text(t.debtsReminderSetting),
          value: user.debtsReminder,
          onChanged: authP.updateDebtsReminder,
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.only(left: 32),
          title: Text(t.dailyReminderSetting),
          value: user.dailyReminder,
          onChanged: authP.updateDailyReminder,
        ),
        SwitchListTile(
          contentPadding: const EdgeInsets.only(left: 32),
          title: Text(t.newsUpdatesSetting),
          value: user.newsUpdates,
          onChanged: authP.updateNewsUpdates,
        ),
        const Divider(),

        // ───────── Account ─────────
        Text(t.accountSection, style: Theme.of(context).textTheme.titleMedium),
        ListTile(
          title: Text(t.changeName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, '/account/name'),
        ),
        ListTile(
          title: Text(t.changeEmail),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, '/account/email'),
        ),
        ListTile(
          title: Text(t.changePhone),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pushNamed(context, '/account/phone'),
        ),
        const Divider(),

        // ───────── Sign Out ─────────
        ListTile(
          title: Text(t.logout, style: TextStyle(color: colors.error)),
          onTap: () => _confirmSignOut(context),
        ),
      ]),
    );
  }

  void _confirmSignOut(BuildContext ctx) {
    final t = S.of(ctx);
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(t.logout),
        content: Text(t.logoutConfirmation),
        actions: [
          TextButton(child: Text(t.cancel), onPressed: () => Navigator.pop(ctx)),
          ElevatedButton(
            child: Text(t.logout),
            onPressed: () {
              try {

                ctx.read<AuthProvider>().signOut();
                print (" i will redirect into the splash now ");
                ctx.go('/splash');
              }catch(e){
                print ("can not sign out error is $e");
              }

            },
          ),
        ],
      ),
    );
  }
}
