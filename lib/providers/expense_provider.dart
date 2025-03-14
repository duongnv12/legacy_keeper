import 'package:flutter/foundation.dart';
import '../models/expense_transaction_model.dart';
import '../services/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  List<ExpenseTransaction> _expenses = [];
  bool _isLoading = false;

  List<ExpenseTransaction> get expenses => _expenses;
  bool get isLoading => _isLoading;

  // Lấy danh sách khoản chi
  Future<void> fetchAllExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await _service.getAllExpenses();
    } catch (e) {
      print("Error fetching expenses: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm khoản chi và đồng bộ với Income
  Future<void> addExpenseAndUpdateIncome(ExpenseTransaction expense) async {
    try {
      await _service.addExpense(expense);
      _expenses.add(expense);
      notifyListeners();
    } catch (e) {
      print("Error adding expense: $e");
    }
  }
}
