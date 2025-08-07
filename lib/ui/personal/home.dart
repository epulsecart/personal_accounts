// lib/ui/personal/personal_module.dart

import 'package:accounts/state/user_module/transactions_provider.dart';
import 'package:accounts/ui/personal/report.dart';
import 'package:accounts/ui/personal/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../state/auth_provider.dart';
import '../dash/module_scaffold.dart';
import 'new_transaction_widget.dart';



// lib/ui/personal/personal_module.dart

class PersonalModule extends StatelessWidget {
  const PersonalModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (!auth.isAuthenticated) {
      return const Center(child: CircularProgressIndicator());
    }

    return PersonalModuleView();
  }
}
class PersonalModuleView extends StatefulWidget {
  const PersonalModuleView({Key? key}) : super(key: key);

  @override
  State<PersonalModuleView> createState() => _PersonalModuleViewState();
}

class _PersonalModuleViewState extends State<PersonalModuleView> {
  String _search = '';

  FocusNode _focus = FocusNode();
  late final TextEditingController _searchCtrl;


  @override
  void initState() {
    _searchCtrl = TextEditingController();

    _focus = FocusNode()
      ..addListener(() => setState(() {}));  // rebuild on focus changes

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final prov= context.watch<TransactionProvider>();
    // TODO: wire these from your providers
    final spent  = prov.summary.totalExpense;
    final income = prov.summary.totalIncome;
    return ModuleScaffold(
      searchController: _searchCtrl,
      searchFocusNode: _focus,
      tabs: [
        Tab(text: t.transactionsTab),
        Tab(text: t.reportsTab),
      ],
      tabViews: [
        TransactionsListView(search: _search,),
        ReportsView(),
      ],
      spentAmount: spent,
      incomeAmount: income,
      getExcel: (){},
      onSettingsTap: () => context.push('/settings'),
      searchText: _search,
      onSearchChanged: (val) => setState(() => _search = val),
      onAddPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => AddTransactionSheet(),
        );
        // open bottom sheet for new transaction
      },
    );
  }
}
