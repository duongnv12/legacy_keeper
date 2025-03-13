import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/annual_fee_model.dart';

class AnnualFeeService {
  final CollectionReference annualFeesCollection =
      FirebaseFirestore.instance.collection('annual_fees');

  // Thêm định mức hàng năm
  Future<void> addAnnualFee(AnnualFee fee) async {
    try {
      await annualFeesCollection.add(fee.toMap());
    } catch (e) {
      print("Error adding annual fee: $e");
      rethrow;
    }
  }

  // Lấy danh sách định mức
  Stream<List<AnnualFee>> getAnnualFees() {
    return annualFeesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AnnualFee.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
