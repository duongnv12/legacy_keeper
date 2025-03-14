import 'package:cloud_firestore/cloud_firestore.dart';

class Ancestor {
  final String id; // Firestore document ID
  final String name; // Tên của tổ tiên
  final String birthDate; // Ngày sinh của tổ tiên
  final String? deathDate; // Ngày mất (tùy chọn)
  final String? notes; // Ghi chú (tùy chọn)
  final DateTime createdAt; // Ngày tạo dữ liệu trong hệ thống

  Ancestor({
    required this.id,
    required this.name,
    required this.birthDate,
    this.deathDate,
    this.notes,
    required this.createdAt,
  });

  // Chuyển đổi từ Firestore thành model
  factory Ancestor.fromFirestore(Map<String, dynamic> data, String id) {
    return Ancestor(
      id: id,
      name: data['name'] ?? '',
      birthDate: data['birthDate'] ?? '',
      deathDate: data['deathDate'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Chuyển đổi từ model sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': birthDate,
      'deathDate': deathDate,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static defaultAncestor() {}
}
