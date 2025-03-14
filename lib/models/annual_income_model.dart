class AnnualIncome {
  final String id;
  final String familyMemberId;
  final String familyMemberName;
  final double annualQuota;
  final double paidAmount;
  final String status;
  final String year;

  AnnualIncome({
    required this.id,
    required this.familyMemberId,
    required this.familyMemberName,
    required this.annualQuota,
    required this.paidAmount,
    required this.status,
    required this.year,
  });

  // Phương thức tạo bản sao với các giá trị thay đổi
  AnnualIncome copyWith({
    double? paidAmount,
    String? status,
  }) {
    return AnnualIncome(
      id: id,
      familyMemberId: familyMemberId,
      familyMemberName: familyMemberName,
      annualQuota: annualQuota,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      year: year,
    );
  }

  // Phương thức chuyển đổi từ Firestore
  factory AnnualIncome.fromFirestore(Map<String, dynamic> data, String id) {
    return AnnualIncome(
      id: id,
      familyMemberId: data['familyMemberId'] ?? '',
      familyMemberName: data['familyMemberName'] ?? '',
      annualQuota: (data['annualQuota'] as num).toDouble(),
      paidAmount: (data['paidAmount'] as num).toDouble(),
      status: data['status'] ?? 'Chưa đóng',
      year: data['year'] ?? '',
    );
  }

  // Phương thức chuyển đổi sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'familyMemberId': familyMemberId,
      'familyMemberName': familyMemberName,
      'annualQuota': annualQuota,
      'paidAmount': paidAmount,
      'status': status,
      'year': year,
    };
  }
}
