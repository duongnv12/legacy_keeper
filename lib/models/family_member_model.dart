import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMember {
  final String id; // Firestore document ID
  final String name; // Tên thành viên
  final String birthYear; // Năm sinh
  final String? parentId; // ID của cha/mẹ
  final DateTime createdAt; // Ngày thêm vào

  FamilyMember({
    required this.id,
    required this.name,
    required this.birthYear,
    this.parentId,
    required this.createdAt,
  });

  // Chuyển đổi từ Firestore sang model
  factory FamilyMember.fromFirestore(Map<String, dynamic> data, String id) {
    return FamilyMember(
      id: id,
      name: data['name'] ?? '',
      birthYear: data['birthYear'] ?? '',
      parentId: data['parentId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Chuyển model thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthYear': birthYear,
      'parentId': parentId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
