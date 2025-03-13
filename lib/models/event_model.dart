import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id; // ID của sự kiện
  final String name; // Tên sự kiện
  final String category; // Danh mục sự kiện
  final DateTime date; // Ngày, giờ
  final String location; // Địa điểm
  final int cost; // Chi phí (nếu có)
  final String description; // Mô tả sự kiện

  Event({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.location,
    required this.cost,
    required this.description,
  });

  // Từ Firestore
  factory Event.fromFirestore(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      cost: data['cost'] ?? 0,
      description: data['description'] ?? '',
    );
  }

  // Lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'date': Timestamp.fromDate(date),
      'location': location,
      'cost': cost,
      'description': description,
    };
  }
}
