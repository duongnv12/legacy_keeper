import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/financial_overview_provider.dart';

class FinancialOverviewScreen extends StatelessWidget {
  const FinancialOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FinancialOverviewProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Financial Overview"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Tổng Thu: ${provider.totalIncome} VNĐ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Tổng Chi: ${provider.totalExpense} VNĐ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Số Dư: ${provider.balance} VNĐ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeGreen,
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text("View Details"),
                onPressed: () {
                  // Điều hướng sang chi tiết báo cáo (thu/chi)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
