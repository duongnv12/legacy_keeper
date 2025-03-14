import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMember {
  final String id; // Firestore document ID
  final String name; // Tên thành viên
  final String birthDate; // Ngày sinh
  final String? deathDate; // Ngày mất (nếu có)
  final String gender; // Giới tính
  final String? address; // Địa chỉ hiện tại
  final String? phoneNumber; // Số điện thoại
  final String? email; // Email liên lạc
  final String? parentId; // ID của cha/mẹ (quan hệ)
  final String? spouseName; // Tên vợ/chồng (nếu đã kết hôn)
  final bool isActive; // Trạng thái Active/Inactive
  final DateTime createdAt; // Ngày tạo

  FamilyMember({
    required this.id,
    required this.name,
    required this.birthDate,
    this.deathDate,
    required this.gender,
    this.address,
    this.phoneNumber,
    this.email,
    this.parentId,
    this.spouseName,
    required this.isActive,
    required this.createdAt,
  });

  // Chuyển đổi từ Firestore sang model
  factory FamilyMember.fromFirestore(Map<String, dynamic> data, String id) {
    return FamilyMember(
      id: id,
      name: data['name'] ?? '',
      birthDate: data['birthDate'] ?? '',
      deathDate: data['deathDate'],
      gender: data['gender'] ?? '',
      address: data['address'],
      phoneNumber: data['phoneNumber'],
      email: data['email'],
      parentId: data['parentId'],
      spouseName: data['spouseName'],
      isActive: data['isActive'] ?? true, // Mặc định là true nếu không có trường isActive
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Chuyển model thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': birthDate,
      'deathDate': deathDate,
      'gender': gender,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'parentId': parentId,
      'spouseName': spouseName,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
