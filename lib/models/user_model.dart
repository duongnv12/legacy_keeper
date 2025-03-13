class User {
  final String id; // ID của người dùng (thường là từ Firebase Auth)
  final String name; // Tên người dùng
  final String email; // Email của người dùng
  final String avatarUrl; // Link ảnh đại diện (nếu có)
  final String role; // Vai trò của người dùng (ví dụ: admin, user)

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '', // Mặc định là rỗng
    this.role = 'user', // Mặc định là "user"
  });

  // Chuyển đổi từ Firestore dữ liệu sang User object
  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      role: data['role'] ?? 'user',
    );
  }

  // Lưu User object vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }
}
