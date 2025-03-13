import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String description;
  final String category;
  final int amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.date,
  });

  // Từ Firestore
  factory Expense.fromFirestore(Map<String, dynamic> data, String id) {
    return Expense(
      id: id,
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      amount: data['amount'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'category': category,
      'amount': amount,
      'date': Timestamp.fromDate(date),
    };
  }
}
