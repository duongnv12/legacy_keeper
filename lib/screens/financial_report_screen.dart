import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/financial_report_provider.dart';
import '../utils/formatters.dart'; // Import tiện ích định dạng

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
    // Tự động tải báo cáo tài chính khi giao diện khởi tạo
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
                  children: [
                    // Tiêu đề biểu đồ
                    const Text(
                      "Income vs Expense",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Biểu đồ tròn
                    Expanded(
                      child: _buildPieChart(provider),
                    ),

                    const SizedBox(height: 32),

                    // Tóm tắt
                    const Text(
                      "Summary",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildSummary(provider),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPieChart(FinancialReportProvider provider) {
    return PieChart(
      PieChartData(
        sections: [
          // Thu nhập
          PieChartSectionData(
            value: provider.totalIncome,
            color: CupertinoColors.activeGreen,
            title: "Income",
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white,
            ),
          ),
          // Chi tiêu
          PieChartSectionData(
            value: provider.totalExpense,
            color: CupertinoColors.destructiveRed,
            title: "Expense",
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.white,
            ),
          ),
        ],
        centerSpaceRadius: 50,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildSummary(FinancialReportProvider provider) {
    final netBalance = provider.totalIncome - provider.totalExpense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Income: ${formatCurrency(provider.totalIncome)}",
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          "Total Expense: ${formatCurrency(provider.totalExpense)}",
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          "Net Balance: ${formatCurrency(netBalance)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: netBalance >= 0
                ? CupertinoColors.activeGreen
                : CupertinoColors.destructiveRed,
          ),
        ),
      ],
    );
  }
}