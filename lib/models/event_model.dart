import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Event {
  final String id; // ID sự kiện
  final String title; // Tên sự kiện
  final String category; // Danh mục sự kiện (ví dụ: "Ngày giỗ", "Họp mặt")
  final DateTime date; // Ngày sự kiện
  final TimeOfDay time; // Giờ sự kiện
  final String location; // Địa điểm
  final double cost; // Chi phí tổ chức
  final String description; // Mô tả chi tiết
  final bool isHidden; // Trạng thái: đã ẩn hay chưa

  Event({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.location,
    required this.cost,
    required this.description,
    required this.isHidden,
  });

  // Phương thức chuyển đổi từ Firestore
  factory Event.fromFirestore(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'Other',
      date: (data['date'] as Timestamp).toDate(),
      time: TimeOfDay(
        hour: data['time']['hour'] ?? 0,
        minute: data['time']['minute'] ?? 0,
      ),
      location: data['location'] ?? '',
      cost: (data['cost'] as num).toDouble(),
      description: data['description'] ?? '',
      isHidden: data['isHidden'] ?? false,
    );
  }

  // Phương thức chuyển đổi sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'date': date,
      'time': {'hour': time.hour, 'minute': time.minute},
      'location': location,
      'cost': cost,
      'description': description,
      'isHidden': isHidden,
    };
  }

  // Tạo một bản sao mới với giá trị cập nhật
  Event copyWith({
    String? title,
    String? category,
    DateTime? date,
    TimeOfDay? time,
    String? location,
    double? cost,
    String? description,
    bool? isHidden,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      cost: cost ?? this.cost,
      description: description ?? this.description,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
