
import 'package:accounts/data/user_model.dart';
import 'package:accounts/services/user_module/transactions_service.dart';
import 'package:accounts/state/group_module/group_provider.dart';
import 'package:accounts/ui/auth/login_screen.dart';
import 'package:accounts/ui/auth/update_profile.dart';
import 'package:accounts/ui/group/widgets/create_new_group_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../state/auth_provider.dart';
import '../dash/module_scaffold.dart';
import 'groups_list_view.dart';
import 'join_group_view.dart';

class GroupsModule extends StatefulWidget {
  const GroupsModule({super.key});

  @override
  State<GroupsModule> createState() => _GroupsModuleState();
}

class _GroupsModuleState extends State<GroupsModule> {
  FocusNode _focus = FocusNode();
  late final TextEditingController _searchCtrl;
  String _search = '';
  double income = 0.0 ;
  double outGoes = 0.0 ;
  @override
  void initState() {
    _searchCtrl = TextEditingController();

    _focus = FocusNode()
      ..addListener(() => setState(() {}));  // rebuild on focus changes

    WidgetsBinding.instance.addPostFrameCallback((_)async{
      try {
        final provider = context.read<GroupProvider>();
        await provider.synchronize();
        for (var group in provider.groups){
          final summary = await provider.getGroupSummary(group.id);
          income =income+ summary.totalIncome;
          outGoes = outGoes + summary.totalExpense;
        }
      }catch(e){
        print("can not sum $e");
      }
      if (mounted) setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final auth = context.watch<AuthProvider>();
    final provider = context.watch<GroupProvider>();
    for (var group in provider.groups){
      Summary summary = provider.groupSummary[group.id]?? Summary(totalExpense: 0.0, totalIncome: 0.0);
      income =income+ summary.totalIncome;
      outGoes = outGoes + summary.totalExpense;
    }
    if (!auth.isAuthenticated || auth.user?.loginMethod == LoginMethod.anonymous) {
      return const LoginScreen();
    }

    if (auth.user?.name == null || auth.user?.phone == null) {
      return const UpdateProfileScreen();
    }
    // final provider = context.read<GroupProvider>();

    return
      ModuleScaffold(
        tabs: [
          Tab(text: t.groupList),
          Tab(text: t.joinNewGroup),
        ],
        tabViews: [
          GroupsListView(search: _search,),
          JoinGroupView(),
          // Container(),
        ],
      spentAmount: outGoes, incomeAmount: income,
        getExcel: (){},
        onSettingsTap: () => context.push('/settings'),
        searchText: _search,
        onSearchChanged: (val) => setState(() => _search = val),
        onAddPressed: () {
          print ("tapped");
          try {
            print ("let us see if provider works here ${provider.groups.length}");
            final scopedContext = context; // Save the correct context

            showDialog(
              context: scopedContext,
              builder: (_) =>  CreateGroupDialog(groupProvider: provider),
            );
          }catch(e){
            print ("erorr$e");
          }
        },
        searchController: _searchCtrl,

        searchFocusNode: _focus,

    );
  }
}
