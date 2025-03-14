import 'package:flutter/cupertino.dart';
import '../services/firebase_auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool isLoading = false;
  String selectedRole = "Thành viên dòng họ";

  final List<String> roles = [
    "Hội đồng gia tộc",
    "Hội đồng tài chính",
    "Thành viên dòng họ",
  ];

  Future<void> _register() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog("Please fill in all the fields.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await _authService.registerWithEmailAndPassword(
        email,
        password,
        name,
        selectedRole,
      );

      if (user != null) {
        _showSuccessDialog("Registration successful! Please login.");
      }
    } catch (e) {
      _showErrorDialog("Registration failed: $e");
    } finally {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                placeholder: "Full Name",
                controller: fullNameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                placeholder: "Email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                placeholder: "Password",
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                placeholder: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const Text("Select Role:"),
              CupertinoButton(
                child: Text(selectedRole),
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => Container(
                      height: 250,
                      color: CupertinoColors.systemBackground,
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (index) {
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
              const SizedBox(height: 32),
              CustomButton(
                text: "Register",
                isLoading: isLoading,
                onPressed: isLoading ? () {} : () => _register(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
