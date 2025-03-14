import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/annual_income_model.dart';

class AnnualIncomeService {
  final CollectionReference incomeCollection =
      FirebaseFirestore.instance.collection('annual_incomes');

  // Lấy danh sách thu nhập hàng năm
  Future<List<AnnualIncome>> getAnnualIncomes(String year) async {
    try {
      final snapshot = await incomeCollection.where('year', isEqualTo: year).get();
      return snapshot.docs.map((doc) {
        return AnnualIncome.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching annual incomes: $e");
      return [];
    }
  }

  // Lấy khoản thu theo thành viên
  Future<AnnualIncome?> getIncomeByFamilyMember(String familyMemberId, String year) async {
    try {
      final snapshot = await incomeCollection
          .where('familyMemberId', isEqualTo: familyMemberId)
          .where('year', isEqualTo: year)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return AnnualIncome.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null; // Không tìm thấy
    } catch (e) {
      print("Error fetching income by family member: $e");
      return null;
    }
  }

  // Thêm mới khoản thu
  Future<void> addIncome(AnnualIncome income) async {
    try {
      await incomeCollection.add(income.toMap());
    } catch (e) {
      print("Error adding income: $e");
      rethrow;
    }
  }

  // Cập nhật khoản thu
  Future<void> updateIncome(String id, AnnualIncome updatedIncome) async {
    try {
      await incomeCollection.doc(id).update(updatedIncome.toMap());
    } catch (e) {
      print("Error updating income: $e");
      rethrow;
    }
  }
}
