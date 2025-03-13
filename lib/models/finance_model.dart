import 'package:cloud_firestore/cloud_firestore.dart';

class FinanceEntry {
  final String id;
  final String type; // "income" hoặc "expense"
  final String description;
  final String memberId; // Với khoản thu
  final String category; // Với khoản chi
  final int amount; // Số tiền
  final DateTime date;

  FinanceEntry({
    required this.id,
    required this.type,
    required this.description,
    this.memberId = '',
    this.category = '',
    required this.amount,
    required this.date,
  });

  // Từ Firestore
  factory FinanceEntry.fromFirestore(Map<String, dynamic> data, String id) {
    return FinanceEntry(
      id: id,
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      memberId: data['memberId'] ?? '',
      category: data['category'] ?? '',
      amount: data['amount'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'memberId': memberId,
      'category': category,
      'amount': amount,
      'date': Timestamp.fromDate(date),
    };
  }
}
