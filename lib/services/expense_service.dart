import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final CollectionReference expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  // Thêm khoản chi
  Future<void> addExpense(Expense expense) async {
    try {
      await expensesCollection.add(expense.toMap());
    } catch (e) {
      print("Error adding expense: $e");
      rethrow;
    }
  }

  // Lấy danh sách khoản chi
  Stream<List<Expense>> getExpenses() {
    return expensesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
