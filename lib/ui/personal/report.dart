// lib/ui/personal/reports_view.dart

import 'package:accounts/data/user_module/categories.dart';
import 'package:accounts/data/user_module/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../state/user_module/category_provider.dart';
import '../../state/user_module/transactions_provider.dart';



enum ReportRange { today, week, month, custom }

class ReportsView extends StatefulWidget {
  const ReportsView({Key? key}) : super(key: key);

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  DateTimeRange? _customRange;
  late DateTime _start, _end;
  ReportType _type = ReportType.net;
  ReportRange _selectedRange = ReportRange.today;    // default
  bool isDownloadingExcel = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _start = DateTime(now.year, now.month, now.day , 0 );
    _end   = DateTime(now.year, now.month , now.day, 23, 59, 59);
    _refresh();
  }

  Future<void> _refresh() async {
    final prov = context.read<TransactionProvider>();
    bars   = await prov.fetchReportData( // we already cached in provider
        start: _start, end: _end, type: _type
    );
    await prov.fetchReportData(start: _start, end: _end, type: _type);
    setState(() {}); // rebuild with new data
  }

  void _pickRange() async {
    final t = S.of(context);
    _selectedRange = ReportRange.custom;
    final today = DateTime.now();
    // clamp end so it’s never after today:
    final safeEnd = _end.isAfter(today) ? today : _end;

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _start, end: safeEnd),
      saveText: t.rangeCustom,

    );
    if (picked != null) {
      print ("end is ${picked.end}");
      _start = picked.start;
      _end   = picked.end.add(Duration(hours: 23));
      await _refresh();
    }
  }

  void getDataForExcel()async{
    setState(() {
      isDownloadingExcel = true;
    });
    try {
      final provider = context.read<TransactionProvider>();
      final catProvider = context.read<CategoryProvider>();
      List<TransactionModel> transactions = provider.transactions ;
      List<CategoryModel> categories = catProvider.categories;
      String date = "${_start.toString().substring(0,10)}-${_end.toString().substring(0,10)}";
      List<Map> filteredDate = [];
      for(final trans in transactions.where((tra)=> (tra.updatedAt?.isAfter(_start)??false) && (tra.updatedAt?.isBefore(_end)??false))){
        String categoryName = '';
        try {
          final currentCar = categories.firstWhere((cat)=>cat.id == trans.categoryId);
          categoryName= currentCar.name;
        }catch(e){

        }
        filteredDate.add({
          'date': trans.updatedAt,
          'amount': trans.amount,
          'desc': trans.description,
          'category': categoryName,
        });
      }
      Map data = {
        'date': date,
        'data' : filteredDate
      };
      await provider.downloadExcel(data);
    }catch(e){
     print (" iam not able to download excel $e");
    }
    setState(() {
      isDownloadingExcel = false;
    });
  }
  var bars   ;
  @override
  Widget build(BuildContext context) {
    final t      = S.of(context);
    final prov   = context.watch<TransactionProvider>();

    final theme  = Theme.of(context);
    final colors = theme.colorScheme;

    return prov.isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1) Date‐range selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDateChip(t.rangeToday,ReportRange.today ,() {
                  final now = DateTime.now();
                  _start = DateTime(now.year, now.month, now.day , 0 );
                  _end   = DateTime(now.year, now.month , now.day, 23, 59, 59);
                  _refresh();
                  _selectedRange = ReportRange.today;
                }),
                _buildDateChip(t.rangeWeek, ReportRange.week,() {
                  final n = DateTime.now();
                  print ("week day is ${n.weekday}"); 
                  _start = n.subtract(Duration(days: n.weekday ));
                  _end   = n.add(Duration(days: 6));
                  _selectedRange = ReportRange.week;

                  _refresh();
                }),
                _buildDateChip(t.rangeMonth, ReportRange.month,() {
                  final n = DateTime.now();
                  _start = DateTime(n.year, n.month, 1);
                  _end   = DateTime(n.year, n.month + 1, 0);
                  _selectedRange = ReportRange.month;

                  _refresh();
                }),
                _buildDateChip(t.rangeCustom,ReportRange.custom ,_pickRange),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2) Expense/Income/Net toggle
          Row(
            children: [
              _buildTypeChip(t.reportTypeNet,     ReportType.net),
              _buildTypeChip(t.reportTypeExpense, ReportType.expense),
              _buildTypeChip(t.reportTypeIncome,  ReportType.income),
            ],
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
          const SizedBox(height: 24),

          // 3) Bars list or empty
          if (bars == null || bars.isEmpty)
            Center(child: Text(t.noReportData, style: theme.textTheme.bodyMedium))
          else
            Expanded(
              child: ListView.separated(
                itemCount: bars.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (ctx, i) {
                  final bar = bars[i];
                  // lookup category details from your CategoryProvider...
                  CategoryModel? cat;
                  try{cat= context.read<CategoryProvider>()
                      .categories.firstWhere((cat)=>cat.id == bar.categoryId);}
                  catch(e){

                  }

                  final label = cat?.name ?? t.noReportData;
                  final color =  Color(cat?.colorValue??00000);
                  return _CategoryBar(
                    label:      label,
                    percent:    bar.percentage,
                    amount:     bar.netValue,
                    barColor:   color,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateChip(String label,ReportRange range,  VoidCallback onTap) {

    final selected = _selectedRange == range; // you could highlight Today/Week etc if desired
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _buildTypeChip(String label, ReportType type) {
    final sel = _type == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: sel,
        onSelected: (_) {
          setState(() => _type = type);
          _refresh();
        },
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String label;
  final double percent;
  final double amount;
  final Color barColor;

  const _CategoryBar({
    required this.label,
    required this.percent,
    required this.amount,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = amount.abs().toStringAsFixed(2);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title + value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyLarge),
            Text(
              (amount < 0 ? "-" : "+") + " ${money}",
              style: theme.textTheme.bodyLarge!
                  .copyWith(color: amount < 0 ? Colors.red : Colors.green),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
      ],
    );
  }
}
