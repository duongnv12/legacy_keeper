import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/financial_overview_provider.dart';
import 'financial_overview_screen.dart';
import 'expense_screen.dart';
import 'contribution_screen.dart';

class FinancialManagementScreen extends StatelessWidget {
  const FinancialManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final financialProvider = Provider.of<FinancialOverviewProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Financial Management"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Overview Section
              Text(
                "Tổng Quan Tài Chính",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tổng Thu: ${financialProvider.totalIncome} VNĐ"),
                    const SizedBox(height: 5),
                    Text("Tổng Chi: ${financialProvider.totalExpense} VNĐ"),
                    const SizedBox(height: 5),
                    Text(
                      "Số Dư: ${financialProvider.balance} VNĐ",
                      style: const TextStyle(color: CupertinoColors.activeGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons Section
              Text(
                "Chọn Hành Động",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CupertinoButton.filled(
                child: const Text("Quản Lý Thu"),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const ContributionScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              CupertinoButton.filled(
                child: const Text("Quản Lý Chi"),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const ExpenseScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              CupertinoButton.filled(
                child: const Text("Tài Chính Tổng Hợp"),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const FinancialOverviewScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
