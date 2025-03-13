import 'package:flutter/cupertino.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/firebase_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final user = await _authService.signInWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _showErrorDialog("Invalid email or password.");
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Login"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                placeholder: "Email",
                controller: emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                placeholder: "Password",
                controller: passwordController,
                obscureText: true, // Fix: Added the missing parameter
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: "Login",
                onPressed: isLoading
                    ? () {}
                    : () {
                        _login(); // Fix: Ensures correct VoidCallback type
                      },
                isLoading: isLoading,
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                child: const Text(
                  "Don't have an account? Register here!",
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
