import 'package:accounts/ui/auth/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../data/user_model.dart';
import '../../state/auth_provider.dart';
import '../auth/update_profile.dart';

class GroupsModule extends StatefulWidget {
  const GroupsModule({super.key});

  @override
  State<GroupsModule> createState() => _GroupsModuleState();
}

class _GroupsModuleState extends State<GroupsModule> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isAuthenticated || auth.user!.loginMethod == LoginMethod.anonymous) {
      return LoginScreen();
    }
    if (auth.user!.name == null || auth.user!.phone == null) {
      return UpdateProfileScreen();
    }
    return Container();  // your normal list of groups
  }  }

