import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/firebase_auth_service.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import 'access_denied_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  bool isLoading = false;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      isLoading = true;
    });

    try {
      final firebaseUser = await _authService.signInWithEmailAndPassword(email, password);
      if (firebaseUser != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.fetchCurrentUser(firebaseUser.uid);

        if (userProvider.currentUser!.isActive) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => const AccessDeniedScreen()),
          );
        }
      }
    } catch (e) {
      _showErrorDialog(e.toString());
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
        title: const Text("Login Failed"),
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
              CupertinoTextField(
                controller: emailController,
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                padding: const EdgeInsets.all(16.0),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: passwordController,
                placeholder: "Password",
                obscureText: true,
                padding: const EdgeInsets.all(16.0),
              ),
              const SizedBox(height: 32),
              CupertinoButton.filled(
                onPressed: isLoading ? null : _login,
                child: isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text("Login"),
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                child: const Text(
                  "Don't have an account? Register here!",
                  style: TextStyle(fontSize: 16, color: CupertinoColors.activeBlue),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
