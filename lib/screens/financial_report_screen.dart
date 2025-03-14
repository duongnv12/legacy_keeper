import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/financial_report_provider.dart';

class FinancialReportScreen extends StatefulWidget {
  final String year;

  const FinancialReportScreen({super.key, required this.year});

  @override
  _FinancialReportScreenState createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  @override
  void initState() {
    super.initState();
    // Tự động tải báo cáo tài chính theo năm khi giao diện khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinancialReportProvider>(context, listen: false)
          .fetchFinancialReport(widget.year);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinancialReportProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Financial Report - ${widget.year}"),
      ),
      child: SafeArea(
        child: provider.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tổng hợp tài chính
                    const Text(
                      "Summary",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Income: ${provider.totalIncome.toStringAsFixed(2)} VND",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Total Expense: ${provider.totalExpense.toStringAsFixed(2)} VND",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Net Balance: ${(provider.totalIncome - provider.totalExpense).toStringAsFixed(2)} VND",
                      style: TextStyle(
                        fontSize: 16,
                        color: (provider.totalIncome - provider.totalExpense) >= 0
                            ? CupertinoColors.activeGreen
                            : CupertinoColors.destructiveRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),

                    // Chi tiết khoản thu
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        "Incomes",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.incomes.length,
                        itemBuilder: (context, index) {
                          final income = provider.incomes[index];
                          return CupertinoListTile(
                            title: Text(income.familyMemberName),
                            subtitle: Text(
                              "Quota: ${income.annualQuota.toStringAsFixed(2)} VND\n"
                              "Paid: ${income.paidAmount.toStringAsFixed(2)} VND\n"
                              "Status: ${income.status}",
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(),

                    // Chi tiết khoản chi
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        "Expenses",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: provider.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = provider.expenses[index];
                          return CupertinoListTile(
                            title: Text(expense.familyMemberName),
                            subtitle: Text(
                              "Amount: ${expense.amount.toStringAsFixed(2)} VND\n"
                              "Date: ${expense.date.toLocal()}",
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
