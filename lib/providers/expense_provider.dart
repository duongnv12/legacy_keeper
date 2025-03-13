import 'package:flutter/foundation.dart';
import '../models/expense_model.dart';
import '../services/expense_service.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> fetchExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _service.getExpenses().listen((fetchedExpenses) {
        _expenses = fetchedExpenses;
        notifyListeners();
      });
    } catch (e) {
      print("Error fetching expenses: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _service.addExpense(expense);
    fetchExpenses(); // Làm mới dữ liệu
  }
}
