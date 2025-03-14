import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _service = UserService();
  User? _currentUser; // Thông tin người dùng hiện tại
  bool _isLoading = false; // Trạng thái tải dữ liệu
  List<User> _users = []; // Danh sách người dùng (dành cho admin quản lý)

  // Getter cho trạng thái và dữ liệu
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  List<User> get users => _users;

  /// **Lấy thông tin người dùng hiện tại dựa trên userId**
  Future<void> fetchCurrentUser(String userId) async {
    _isLoading = true;
    notifyListeners(); // Thông báo trạng thái tải bắt đầu

    try {
      _currentUser = await _service.getUser(userId);
    } catch (e) {
      print("Error fetching current user: $e");
    } finally {
      _isLoading = false;
      notifyListeners(); // Thông báo trạng thái tải kết thúc
    }
  }

  /// **Lấy danh sách người dùng (Admin sử dụng)**
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Lấy danh sách tất cả người dùng từ Firestore
      final snapshot = await _service.userCollection.get();
      _users = snapshot.docs
          .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// **Lưu hoặc cập nhật thông tin người dùng**
  Future<void> saveUser(User user) async {
    try {
      await _service.updateUser(user);
      // Nếu là người dùng hiện tại, cập nhật trạng thái
      if (_currentUser != null && _currentUser!.id == user.id) {
        _currentUser = user;
      }
      notifyListeners();
    } catch (e) {
      print("Error saving user: $e");
    }
  }

  /// **Thay đổi trạng thái Active/Inactive của người dùng**
  Future<void> setUserActiveState(String userId, bool isActive) async {
    try {
      await _service.setUserActiveState(userId, isActive);
      // Cập nhật trạng thái trong danh sách người dùng
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex] = User(
          id: _users[userIndex].id,
          name: _users[userIndex].name,
          email: _users[userIndex].email,
          role: _users[userIndex].role,
          avatarUrl: _users[userIndex].avatarUrl,
          isActive: isActive,
        );
      }
      notifyListeners();
    } catch (e) {
      print("Error updating user active state: $e");
    }
  }

  /// **Kiểm tra quyền của người dùng dựa trên vai trò**
  bool hasPermission(String requiredRole) {
    const rolesHierarchy = ["Thành viên dòng họ", "Hội đồng tài chính", "Hội đồng gia tộc"];
    if (_currentUser == null) return false;
    final currentRole = _currentUser!.role;
    return rolesHierarchy.indexOf(currentRole) >= rolesHierarchy.indexOf(requiredRole);
  }

    /// **Đăng xuất người dùng**
  void logout() {
    _currentUser = null; // Xóa thông tin người dùng hiện tại
    notifyListeners();
  }
}
