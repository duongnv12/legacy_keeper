import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _service = UserService();
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Lấy thông tin người dùng hiện tại
  Future<void> fetchCurrentUser(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _service.getUser(userId);
    } catch (e) {
      print("Error fetching current user: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // Thêm hoặc cập nhật người dùng
  Future<void> saveUser(User user) async {
    await _service.addUser(user); // Hoặc updateUser nếu cần
    _currentUser = user;
    notifyListeners();
  }
}
