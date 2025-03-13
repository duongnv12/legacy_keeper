import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/finance_model.dart';

class FinanceService {
  final CollectionReference financeCollection =
      FirebaseFirestore.instance.collection('finances');

  // Thêm mục tài chính
  Future<void> addFinanceEntry(FinanceEntry entry) async {
    try {
      await financeCollection.add(entry.toMap());
    } catch (e) {
      print("Error adding finance entry: $e");
      rethrow;
    }
  }

  // Lấy danh sách tài chính
  Stream<List<FinanceEntry>> getFinanceEntries() {
    return financeCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FinanceEntry.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
