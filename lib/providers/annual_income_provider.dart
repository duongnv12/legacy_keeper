import 'package:flutter/foundation.dart';
import '../models/annual_income_model.dart';
import '../services/annual_income_service.dart';

class AnnualIncomeProvider with ChangeNotifier {
  final AnnualIncomeService _service = AnnualIncomeService();
  List<AnnualIncome> _annualIncomes = [];
  bool _isLoading = false;

  List<AnnualIncome> get annualIncomes => _annualIncomes;
  bool get isLoading => _isLoading;

  // Lấy danh sách thu nhập hàng năm
  Future<void> fetchAnnualIncomes(String year) async {
    _isLoading = true;
    notifyListeners();

    try {
      _annualIncomes = await _service.getAnnualIncomes(year);
    } catch (e) {
      print("Error fetching annual incomes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cập nhật khoản thu sau khi đồng bộ từ Expense
  Future<void> updateIncomeAfterExpense(
      String familyMemberId, String year, double paidAmount) async {
    try {
      final income = _annualIncomes.firstWhere(
        (i) => i.familyMemberId == familyMemberId && i.year == year,
        orElse: () => AnnualIncome(
          id: '', // Giá trị mặc định
          familyMemberId: familyMemberId,
          familyMemberName: "Unknown",
          annualQuota: 0.0,
          paidAmount: 0.0,
          status: "Chưa đóng",
          year: year,
        ),
      );

      if (income.id.isNotEmpty) {
        final updatedIncome = income.copyWith(
          paidAmount: income.paidAmount + paidAmount,
          status: (income.paidAmount + paidAmount) >= income.annualQuota
              ? "Đã đóng"
              : "Chưa đóng",
        );

        await _service.updateIncome(updatedIncome.id, updatedIncome);

        // Cập nhật local state
        final index = _annualIncomes.indexWhere((i) => i.id == updatedIncome.id);
        if (index != -1) {
          _annualIncomes[index] = updatedIncome;
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error updating income after expense: $e");
    }
  }

  // Thêm khoản thu mới
  Future<void> addIncome(AnnualIncome income) async {
    try {
      await _service.addIncome(income);
      _annualIncomes.add(income);
      notifyListeners();
    } catch (e) {
      print("Error adding income: $e");
    }
  }
}
