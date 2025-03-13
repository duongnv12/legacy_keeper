import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ancestor_model.dart';

class AncestorProvider with ChangeNotifier {
  List<Ancestor> _ancestors = [];
  bool _isLoading = false;

  List<Ancestor> get ancestors => _ancestors;
  bool get isLoading => _isLoading;

  // Lấy dữ liệu Ông Tổ từ Firestore
  Future<void> fetchAncestors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ancestors')
          .orderBy('createdAt', descending: true)
          .get();

      _ancestors = snapshot.docs
          .map((doc) => Ancestor.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Error fetching ancestors: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Thêm một Ông Tổ mới
  Future<void> addAncestor(Ancestor ancestor) async {
    try {
      await FirebaseFirestore.instance.collection('ancestors').add(ancestor.toMap());
      _ancestors.insert(0, ancestor); // Thêm mới vào danh sách
      notifyListeners();
    } catch (e) {
      print("Error adding ancestor: $e");
    }
  }
}
