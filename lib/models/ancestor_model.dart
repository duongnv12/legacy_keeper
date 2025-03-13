import 'package:cloud_firestore/cloud_firestore.dart';

class Ancestor {
  final String id;
  final String name;
  final String birthDate;
  final String? deathDate;
  final String? notes;
  final DateTime createdAt;

  Ancestor({
    required this.id,
    required this.name,
    required this.birthDate,
    this.deathDate,
    this.notes,
    required this.createdAt,
  });

  factory Ancestor.fromFirestore(Map<String, dynamic> data, String id) {
    return Ancestor(
      id: id,
      name: data['name'] ?? '',
      birthDate: data['birthDate'] ?? '',
      deathDate: data['deathDate'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': birthDate,
      'deathDate': deathDate,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Firestore Timestamp
    };
  }
}
