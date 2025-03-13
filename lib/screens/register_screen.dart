import 'package:flutter/cupertino.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/firebase_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  String selectedRole = "Thành viên dòng họ"; // Vai trò mặc định
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isLoading = false;

  final List<String> roles = [
    "Hội đồng gia tộc",
    "Hội đồng tài chính",
    "Thành viên dòng họ",
  ];

  Future<void> _register() async {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Kiểm tra dữ liệu hợp lệ
    if (fullName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorDialog("Please fill in all required fields.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Gọi dịch vụ Firebase Auth để đăng ký
    final user = await _authService.registerWithEmailAndPassword(email, password);

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      _showSuccessDialog("Registration successful!");
    } else {
      _showErrorDialog("Registration failed. Please try again.");
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
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Navigate back to Login
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Register"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  placeholder: "Họ và tên",
                  controller: fullNameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "Username",
                  controller: usernameController,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  placeholder: "Email",
                  controller: emailController,
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      placeholder: "Password",
                      controller: passwordController,
                      obscureText: isPasswordObscured,
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          isPasswordObscured = !isPasswordObscured;
                        });
                      },
                      child: Icon(
                        isPasswordObscured
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      placeholder: "Confirm Password",
                      controller: confirmPasswordController,
                      obscureText: isConfirmPasswordObscured,
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordObscured = !isConfirmPasswordObscured;
                        });
                      },
                      child: Icon(
                        isConfirmPasswordObscured
                            ? CupertinoIcons.eye_slash_fill
                            : CupertinoIcons.eye_fill,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Chọn vai trò:",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(selectedRole),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => Container(
                        height: 200,
                        color: CupertinoColors.systemBackground,
                        child: CupertinoPicker(
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedRole = roles[index];
                            });
                          },
                          children: roles.map((role) => Text(role)).toList(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: "Register",
                  onPressed: isLoading
                      ? () {}
                      : () {
                          _register();
                        },
                  isLoading: isLoading,
                ),
                const SizedBox(height: 20),
                CupertinoButton(
                  child: const Text(
                    "Already have an account? Log in here!",
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
