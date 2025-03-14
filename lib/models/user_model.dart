class User {
  final String id; // ID từ Firebase Auth
  final String name; // Tên đầy đủ của người dùng
  final String email; // Email
  final String role; // Vai trò
  final String? avatarUrl; // Link ảnh đại diện (tùy chọn)
  final bool isActive; // Trạng thái kích hoạt (true = Active, false = Inactive)

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.isActive = true, // Mặc định là Active
  });

  // Từ Firestore sang User object
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'Thành viên dòng họ',
      avatarUrl: data['avatarUrl'],
      isActive: data['isActive'] ?? true, // Active mặc định
    );
  }

  // Từ User object sang Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'isActive': isActive,
    };
  }
}
