import 'package:cloud_firestore/cloud_firestore.dart';

class Contribution {
  final String id; // ID của khoản thu
  final String memberId; // ID thành viên đóng góp
  final int amount; // Số tiền đóng góp
  final String status; // Trạng thái (Đã đóng, Chưa đóng)
  final DateTime date; // Ngày đóng góp

  Contribution({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.status,
    required this.date,
  });

  // Từ Firestore
  factory Contribution.fromFirestore(Map<String, dynamic> data, String id) {
    return Contribution(
      id: id,
      memberId: data['memberId'] ?? '',
      amount: data['amount'] ?? 0,
      status: data['status'] ?? 'Chưa đóng',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  // Lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'amount': amount,
      'status': status,
      'date': Timestamp.fromDate(date),
    };
  }
}
