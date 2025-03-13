import 'package:flutter/foundation.dart';
import '../models/family_member_model.dart';
import '../services/family_member_service.dart';

class FamilyMemberProvider with ChangeNotifier {
  final FamilyMemberService _service = FamilyMemberService();
  List<FamilyMember> _familyMembers = [];
  bool _isLoading = false;

  List<FamilyMember> get familyMembers => _familyMembers;
  bool get isLoading => _isLoading;

  // Lấy dữ liệu từ Firestore
  Future<void> fetchFamilyMembers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final familyMembersStream = _service.getFamilyMembers();
      familyMembersStream.listen((members) {
        _familyMembers = members;
        notifyListeners(); // Cập nhật UI
      });
    } catch (e) {
      print("Error fetching family members: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Thêm thành viên mới
  Future<void> addFamilyMember(FamilyMember member) async {
    try {
      await _service.addFamilyMember(member);
      _familyMembers.add(member);
      notifyListeners(); // Cập nhật UI
    } catch (e) {
      print("Error adding family member: $e");
    }
  }

  // Chỉnh sửa thành viên
  Future<void> updateFamilyMember(String id, Map<String, dynamic> updatedData) async {
    try {
      await _service.updateFamilyMember(id, updatedData);
      // Cập nhật local state
      final index = _familyMembers.indexWhere((member) => member.id == id);
      if (index != -1) {
        _familyMembers[index] = FamilyMember.fromFirestore(updatedData, id);
        notifyListeners();
      }
    } catch (e) {
      print("Error updating family member: $e");
    }
  }

  // Xóa thành viên
  Future<void> deleteFamilyMember(String id) async {
    try {
      await _service.deleteFamilyMember(id);
      _familyMembers.removeWhere((member) => member.id == id);
      notifyListeners(); // Cập nhật UI
    } catch (e) {
      print("Error deleting family member: $e");
    }
  }
}
