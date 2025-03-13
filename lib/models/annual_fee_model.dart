class AnnualFee {
  final String id; // ID của định mức
  final int amount; // Số tiền định mức (VNĐ)
  final int year; // Năm áp dụng

  AnnualFee({
    required this.id,
    required this.amount,
    required this.year,
  });

  // Từ Firestore
  factory AnnualFee.fromFirestore(Map<String, dynamic> data, String id) {
    return AnnualFee(
      id: id,
      amount: data['amount'],
      year: data['year'],
    );
  }

  // Lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'year': year,
    };
  }
}
