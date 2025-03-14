import 'package:flutter/foundation.dart';
import '../services/financial_report_service.dart';
import '../models/annual_income_model.dart';
import '../models/expense_transaction_model.dart';

class FinancialReportProvider with ChangeNotifier {
  final FinancialReportService _service = FinancialReportService();
  double _totalIncome = 0;
  double _totalExpense = 0;
  List<AnnualIncome> _incomes = [];
  List<ExpenseTransaction> _expenses = [];
  bool _isLoading = false;

  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  List<AnnualIncome> get incomes => _incomes;
  List<ExpenseTransaction> get expenses => _expenses;
  bool get isLoading => _isLoading;

  // Lấy báo cáo tài chính
  Future<void> fetchFinancialReport(String year) async {
    _isLoading = true;
    notifyListeners();

    try {
      final report = await _service.generateFinancialReport(year);
      _totalIncome = report['totalIncome'];
      _totalExpense = report['totalExpense'];
      _incomes = report['incomes'];
      _expenses = report['expenses'];
    } catch (e) {
      print("Error fetching financial report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
