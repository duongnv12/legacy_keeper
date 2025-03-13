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

  // Chỉnh sửa thông tin thành viên
  Future<void> updateFamilyMember(String id, Map<String, dynamic> updatedData) async {
    try {
      await familyMembersCollection.doc(id).update(updatedData);
    } catch (e) {
      print("Error updating family member: $e");
      rethrow;
    }
  }

  // Xóa thành viên
  Future<void> deleteFamilyMember(String id) async {
    try {
      await familyMembersCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting family member: $e");
      rethrow;
    }
  }
}
