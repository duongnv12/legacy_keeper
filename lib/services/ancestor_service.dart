import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ancestor_model.dart';

class AncestorService {
  final CollectionReference ancestorsCollection =
      FirebaseFirestore.instance.collection('ancestors');

  // Hàm thêm ancestor mới vào Firestore
  Future<void> addAncestor(Ancestor ancestor) async {
    try {
      await ancestorsCollection.add(ancestor.toMap());
    } catch (e) {
      print("Error adding ancestor: $e");
      rethrow; // Ném lại lỗi để xử lý phía trên
    }
  }

  // Hàm lấy danh sách ancestor từ Firestore theo thời gian tạo
  Stream<List<Ancestor>> getAncestors() {
    return ancestorsCollection
        .orderBy('createdAt', descending: true) // Sắp xếp theo thời gian giảm dần
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Ancestor.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
