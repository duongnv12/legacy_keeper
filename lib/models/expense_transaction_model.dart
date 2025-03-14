import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseTransaction {
  final String id; // ID giao dịch
  final String familyMemberId; // ID thành viên gia đình
  final String familyMemberName; // Tên thành viên gia đình
  final String title; // Tiêu đề khoản chi
  final double amount; // Số tiền chi tiêu
  final String category; // Danh mục (e.g., "Sự kiện", "Duy trì cơ sở vật chất")
  final String description; // Mô tả chi tiết
  final DateTime date; // Ngày thực hiện giao dịch

  ExpenseTransaction({
    required this.id,
    required this.familyMemberId,
    required this.familyMemberName,
    required this.title,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  // Chuyển đổi từ Firestore sang object
  factory ExpenseTransaction.fromFirestore(Map<String, dynamic> data, String id) {
    return ExpenseTransaction(
      id: id,
      familyMemberId: data['familyMemberId'] ?? '',
      familyMemberName: data['familyMemberName'] ?? '',
      title: data['title'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Chuyển đổi object sang Firestore
  Map<String, dynamic> toMap() {
    return {
      'familyMemberId': familyMemberId,
      'familyMemberName': familyMemberName,
      'title': title,
      'amount': amount,
      'category': category,
      'description': description,
      'date': Timestamp.fromDate(date),
    };
  }
}
