import 'package:accounts/data/user_module/transactions.dart';
import 'package:accounts/generated/l10n.dart';
import 'package:accounts/theme/theme_consts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../data/groups_module/group_transaction_model.dart';
import '../../../state/auth_provider.dart';
import '../../../state/group_module/group_provider.dart';
import '../../../state/group_module/group_transaction_provider.dart';

class SummaryTabView extends StatefulWidget {
  final String groupId;
  final String groupName;
  const SummaryTabView({super.key, required this.groupId, required this.groupName});

  @override
  State<SummaryTabView> createState() => _SummaryTabViewState();
}

class _SummaryTabViewState extends State<SummaryTabView> {
  DateTimeRange? _range;
  bool isDownloadingExcel = false;

  void getDataForExcel() async{
    try{
      final provider = context.read<GroupTransactionProvider>();
      List<GroupTransactionModel> trans = provider.transactions;
      List <GroupTransactionModel> filteredTrans = [];
      if (_range != null) {
        filteredTrans = trans.where(
                (t) =>
            t.updatedAt.isAfter(_range!.start) &&
                t.updatedAt.isBefore(_range!.end)
        ).toList();
      } else {
        filteredTrans = trans;
      }
      Map data = {'name': widget.groupName};
      List transactionsForexcl = [];
      for (final tra in filteredTrans) {
        transactionsForexcl.add({
          'date': tra.date.toString(),
          'amount': tra.amount.toString(),
          'desc': tra.description,
          'from': tra.payerName.toString(),
          'to': tra.receiverName.toString(),
          'status': tra.isApproved ? S
              .of(context)
              .approved : S
              .of(context)
              .pending,
        });
      }
      data.addAll({'data': transactionsForexcl});
      await provider.downloadExcel(data);
    }catch(e){
      print("error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final colors = Theme.of(context).colorScheme;
    final txnProvider = context.watch<GroupTransactionProvider>();
    final groupProvider = context.watch<GroupProvider>();
    final auth = context.read<AuthProvider>();
    final summary = txnProvider.summary;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spaceM),
      child: RefreshIndicator(
        onRefresh: ()async{
          await context.read<GroupTransactionProvider>().synchronize();
          await context.read<GroupProvider>().synchronize();
        },
        child: ListView(
          shrinkWrap: true,

          children: [
            // Title + Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.summary, style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () async {
                    final now = DateTime.now();
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(now.year - 2),
                      lastDate: DateTime(now.year + 1),
                      initialDateRange: _range,
                    );
                    if (range != null) {
                      setState(() => _range = range);
                      txnProvider.getSummary(
                        start: range.start,
                        end: range.end,
                      );
                    }
                  },
                )
              ],
            ),

            const SizedBox(height: AppConstants.spaceL),

            // Expense / Income Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SummaryTile(
                  label: t.expense,
                  amount: summary.totalExpense,
                  color: colors.error,
                ),
                _SummaryTile(
                  label: t.income,
                  amount: summary.totalIncome,
                  color: colors.primary,
                ),
              ],
            ),

            const Divider(height: 32),

            // Pie Chart
            FutureBuilder<Map<String, double>>(
              future: groupProvider.getMemberBalances(widget.groupId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final balances = snapshot.data!;
                final total = balances.values.fold(0.0, (a, b) => a + b.abs());

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.balancePerMember,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppConstants.spaceS),
                    if (balances.isEmpty)
                      Text(t.noData)
                    else
                      AspectRatio(
                        aspectRatio: 1.3,
                        child: PieChart(
                          PieChartData(
                            sections: balances.entries.map((e) {
                              final percentage = total == 0 ? 0 : (e.value.abs() / total) * 100;
                              return PieChartSectionData(
                                title: '${percentage.toStringAsFixed(1)}%',
                                value: e.value.abs(),
                                color: e.key == auth.user!.uid
                                    ? colors.primary
                                    : colors.secondary,
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),


                    const SizedBox(height: 24),
                    ElevatedButton(onPressed:
                    isDownloadingExcel? (){}:
                        (){
                      getDataForExcel();
                    }, child:
                    isDownloadingExcel? Center(
                      child: CircularProgressIndicator(),
                    )
                        :
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(t.getexcel),
                        Icon(Icons.download)
                      ],
                    )),

                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);

    return Column(
      children: [
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppConstants.spaceS),
        Text(
          formatter.format(amount),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
