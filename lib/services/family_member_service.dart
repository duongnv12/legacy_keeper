import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family_member_model.dart';

class FamilyMemberService {
  final CollectionReference familyMembersCollection =
      FirebaseFirestore.instance.collection('family_members');

  // Lấy danh sách tất cả các thành viên
  Stream<List<FamilyMember>> getFamilyMembers() {
    return familyMembersCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return FamilyMember.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      },
    );
  }

  // Thêm thành viên mới
  Future<void> addFamilyMember(FamilyMember member) async {
    try {
      await familyMembersCollection.add(member.toMap());
    } catch (e) {
      print("Error adding family member: $e");
      rethrow;
    }
  }

  // Cập nhật thông tin thành viên
  Future<void> updateFamilyMember(String id, Map<String, dynamic> updatedData) async {
    try {
      await familyMembersCollection.doc(id).update(updatedData);
    } catch (e) {
      print("Error updating family member: $e");
      rethrow;
    }
  }

  // Thay đổi trạng thái Active/Inactive của thành viên
  Future<void> setActiveState(String id, bool isActive) async {
    try {
      await familyMembersCollection.doc(id).update({'isActive': isActive});
    } catch (e) {
      print("Error updating active state for family member: $e");
      rethrow;
    }
  }
}
