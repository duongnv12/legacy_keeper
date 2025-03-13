import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contribution_model.dart';

class ContributionService {
  final CollectionReference contributionsCollection =
      FirebaseFirestore.instance.collection('contributions');

  // Lấy danh sách các khoản thu
  Stream<List<Contribution>> getContributions() {
    return contributionsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Contribution.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Thêm khoản thu mới
  Future<void> addContribution(Contribution contribution) async {
    try {
      await contributionsCollection.add(contribution.toMap());
    } catch (e) {
      print("Error adding contribution: $e");
      rethrow;
    }
  }

  // Xóa khoản thu
  Future<void> deleteContribution(String id) async {
    try {
      await contributionsCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting contribution: $e");
      rethrow;
    }
  }
}
