import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/ancestor_model.dart';
import '../services/ancestor_service.dart';

class AncestorProvider with ChangeNotifier {
  final AncestorService _ancestorService = AncestorService(); // Gọi tới service
  List<Ancestor> _ancestors = [];
  bool _isLoading = false; // Trạng thái tải dữ liệu

  // Getter cho danh sách ancestor và trạng thái tải
  List<Ancestor> get ancestors => _ancestors;
  bool get isLoading => _isLoading;

  // Lấy danh sách ancestor từ Firestore
  Future<void> fetchAncestors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ancestors')
          .orderBy('createdAt', descending: true)
          .get();

      _ancestors = snapshot.docs.map((doc) {
        // Kiểm tra dữ liệu trước khi ánh xạ
        final data = doc.data();
        return Ancestor.fromFirestore(data, doc.id);
            }).toList();
    } catch (e) {
      print("Error fetching ancestors: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm một ancestor mới
  Future<void> addAncestor(Ancestor ancestor) async {
    try {
      await _ancestorService.addAncestor(ancestor);
      _ancestors.insert(0, ancestor); // Thêm vào đầu danh sách
      notifyListeners();
    } catch (e) {
      print("Error adding ancestor: $e");
    }
  }
}
