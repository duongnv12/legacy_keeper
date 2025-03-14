import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // Đăng ký với email và mật khẩu
  Future<firebase_auth.User?> registerWithEmailAndPassword(
      String email, String password, String name, String role) async {
    try {
      // Tạo tài khoản Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Lưu thông tin người dùng vào Firestore
        final newUser = User(
          id: firebaseUser.uid,
          name: name,
          email: email,
          role: role,
          isActive: true, // Mặc định là Active
        );
        await userCollection.doc(firebaseUser.uid).set(newUser.toMap());
        return firebaseUser;
      }
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
    return null;
  }

  // Đăng nhập với email và mật khẩu
  Future<firebase_auth.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      // Đăng nhập qua Firebase Auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Kiểm tra trạng thái Active từ Firestore
        final snapshot = await userCollection.doc(firebaseUser.uid).get();
        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          final user = User.fromFirestore(userData, firebaseUser.uid);

          // Kiểm tra trạng thái kích hoạt (Active)
          if (user.isActive) {
            return firebaseUser; // Đăng nhập thành công
          } else {
            // Đăng xuất nếu người dùng Inactive
            await signOut();
            throw Exception("Tài khoản của bạn đã bị vô hiệu hóa.");
          }
        }
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
    return null;
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Lấy thông tin người dùng hiện tại từ Firebase Auth
  firebase_auth.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Lấy trạng thái Active/Inactive của người dùng từ Firestore
  Future<bool> isUserActive(String userId) async {
    try {
      final snapshot = await userCollection.doc(userId).get();
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        return userData['isActive'] ?? false;
      }
      return false;
    } catch (e) {
      print("Error checking user active status: $e");
      return false;
    }
  }
}
