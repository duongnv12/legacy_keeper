import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  // Load thông tin người dùng từ Firebase Auth
  void _loadUserInfo() async {
    final authService = FirebaseAuthService();
    final firebaseUser = authService.getCurrentUser();

    if (firebaseUser != null) {
      setState(() {
        emailController.text = firebaseUser.email ?? '';
      });

      // Lấy thông tin bổ sung từ Firestore
      final userSnapshot = await authService.userCollection.doc(firebaseUser.uid).get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final user = User.fromFirestore(userData, firebaseUser.uid);

        setState(() {
          nameController.text = user.name;
        });
      }
    }
  }

  Future<void> _updateUserInfo() async {
    final authService = FirebaseAuthService();
    final firebaseUser = authService.getCurrentUser();

    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Cập nhật thông tin người dùng trong Firestore
      final updatedUser = User(
        id: firebaseUser!.uid,
        name: nameController.text,
        email: emailController.text,
        role: "Thành viên dòng họ", // Có thể dùng role mặc định hoặc giữ nguyên từ trước
        isActive: true, // Giữ trạng thái Active
      );

      await authService.userCollection.doc(firebaseUser.uid).update(updatedUser.toMap());

      setState(() {
        isLoading = false;
      });

      _showSuccessDialog("Information updated successfully!");
    } catch (e) {
      print("Error updating user info: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Profile"),
      ),
      child: SafeArea(
        child: isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CupertinoTextField(
                      controller: nameController,
                      placeholder: "Full Name",
                      padding: const EdgeInsets.all(16.0),
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: emailController,
                      placeholder: "Email",
                      keyboardType: TextInputType.emailAddress,
                      padding: const EdgeInsets.all(16.0),
                      enabled: false, // Email không chỉnh sửa
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton.filled(
                      onPressed: _updateUserInfo,
                      child: const Text("Update Profile"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
