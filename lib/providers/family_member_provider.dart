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

  // Cập nhật thông tin thành viên
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

  // Thay đổi trạng thái Active/Inactive
  Future<void> setActiveState(String id, bool isActive) async {
    try {
      await _service.setActiveState(id, isActive);
      // Cập nhật local state
      final index = _familyMembers.indexWhere((member) => member.id == id);
      if (index != -1) {
        _familyMembers[index] = FamilyMember(
          id: _familyMembers[index].id,
          name: _familyMembers[index].name,
          birthDate: _familyMembers[index].birthDate,
          deathDate: _familyMembers[index].deathDate,
          gender: _familyMembers[index].gender,
          address: _familyMembers[index].address,
          phoneNumber: _familyMembers[index].phoneNumber,
          email: _familyMembers[index].email,
          parentId: _familyMembers[index].parentId,
          spouseName: _familyMembers[index].spouseName,
          createdAt: _familyMembers[index].createdAt,
          isActive: isActive, // Thay đổi trạng thái
        );
        notifyListeners();
      }
    } catch (e) {
      print("Error updating active state: $e");
    }
  }
}
