import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_transaction_model.dart';

class ExpenseService {
  final CollectionReference expenseCollection =
      FirebaseFirestore.instance.collection('expenses');

  // Lấy danh sách tất cả khoản chi
  Future<List<ExpenseTransaction>> getAllExpenses() async {
    try {
      final snapshot = await expenseCollection.get();
      return snapshot.docs.map((doc) {
        return ExpenseTransaction.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print("Error fetching expenses: $e");
      return [];
    }
  }

  // Lấy danh sách khoản chi theo thành viên
  Future<List<ExpenseTransaction>> getExpensesByFamilyMember(String familyMemberId) async {
    try {
      final snapshot = await expenseCollection
          .where('familyMemberId', isEqualTo: familyMemberId)
          .get();
      return snapshot.docs.map((doc) {
        return ExpenseTransaction.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print("Error fetching expenses by family member: $e");
      return [];
    }
  }

  // Thêm khoản chi mới
  Future<void> addExpense(ExpenseTransaction expense) async {
    try {
      await expenseCollection.add(expense.toMap());
    } catch (e) {
      print("Error adding expense: $e");
      rethrow;
    }
  }

  // Cập nhật khoản chi
  Future<void> updateExpense(String id, ExpenseTransaction expense) async {
    try {
      await expenseCollection.doc(id).update(expense.toMap());
    } catch (e) {
      print("Error updating expense: $e");
      rethrow;
    }
  }
}
