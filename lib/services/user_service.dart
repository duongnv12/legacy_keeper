import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Lấy thông tin người dùng
  Future<User?> getUser(String userId) async {
    try {
      final snapshot = await userCollection.doc(userId).get();
      if (snapshot.exists) {
        return User.fromFirestore(snapshot.data() as Map<String, dynamic>, userId);
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Thêm người dùng mới
  Future<void> addUser(User user) async {
    try {
      await userCollection.doc(user.id).set(user.toMap());
    } catch (e) {
      print("Error adding user: $e");
      rethrow;
    }
  }

  // Cập nhật thông tin người dùng
  Future<void> updateUser(User user) async {
    try {
      await userCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  // Thay đổi trạng thái Active/Inactive
  Future<void> setUserActiveState(String userId, bool isActive) async {
    try {
      await userCollection.doc(userId).update({'isActive': isActive});
    } catch (e) {
      print("Error updating user active state: $e");
      rethrow;
    }
  }
}
