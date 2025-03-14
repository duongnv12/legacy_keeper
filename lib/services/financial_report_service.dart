import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/annual_income_model.dart';
import '../models/expense_transaction_model.dart';

class FinancialReportService {
  final CollectionReference incomeCollection =
      FirebaseFirestore.instance.collection('annual_incomes');
  final CollectionReference expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  /// Hàm tổng hợp báo cáo tài chính theo năm
  Future<Map<String, dynamic>> generateFinancialReport(String year) async {
    try {
      // Lấy tất cả khoản thu trong năm từ Firestore
      final incomeSnapshot =
          await incomeCollection.where('year', isEqualTo: year).get();
      final incomes = incomeSnapshot.docs.map((doc) {
        return AnnualIncome.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // Tính tổng số tiền thu (paidAmount)
      final double totalIncome = incomes.fold(0.0, (sum, income) => sum + income.paidAmount);

      // Lấy tất cả khoản chi trong năm từ Firestore
      final expenseSnapshot = await expenseCollection.get();
      final expenses = expenseSnapshot.docs.map((doc) {
        return ExpenseTransaction.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).where((expense) => expense.date.year.toString() == year).toList();

      // Tính tổng số tiền chi tiêu
      final double totalExpense = expenses.fold(0.0, (sum, expense) => sum + expense.amount);

      // Trả về dữ liệu tổng hợp
      return {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
        'incomes': incomes,
        'expenses': expenses,
      };
    } catch (e) {
      // Xử lý ngoại lệ nếu có lỗi xảy ra
      print("Error generating financial report: $e");
      return {
        'totalIncome': 0.0,
        'totalExpense': 0.0,
        'incomes': [],
        'expenses': [],
      };
    }
  }
}
