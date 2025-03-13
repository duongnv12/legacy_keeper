import 'package:flutter/foundation.dart';
import '../providers/expense_provider.dart';
import '../providers/contribution_provider.dart';

class FinancialOverviewProvider with ChangeNotifier {
  final ExpenseProvider expenseProvider;
  final ContributionProvider contributionProvider;

  FinancialOverviewProvider({
    required this.expenseProvider,
    required this.contributionProvider,
  });

  int get totalIncome {
    return contributionProvider.contributions.fold(
      0,
      (sum, contribution) => sum + contribution.amount,
    );
  }

  int get totalExpense {
    return expenseProvider.expenses.fold(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  int get balance {
    return totalIncome - totalExpense;
  }
}
