import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ancestor_model.dart';

class AncestorService {
  final CollectionReference ancestorsCollection =
      FirebaseFirestore.instance.collection('ancestors');

  // Hàm thêm Ông Tổ vào Firestore
  Future<void> addAncestor(Ancestor ancestor) async {
    try {
      await ancestorsCollection.add(ancestor.toMap());
    } catch (e) {
      print("Error adding ancestor: $e");
      rethrow;
    }
  }

  // Hàm lấy danh sách Ông Tổ từ Firestore
  Stream<List<Ancestor>> getAncestors() {
    return ancestorsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ancestor.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
