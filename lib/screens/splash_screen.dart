import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _checkLoginStatus(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    await Future.delayed(const Duration(seconds: 2)); // Hiệu ứng chờ (giả lập loading)

    // Điều hướng dựa trên trạng thái đăng nhập
    if (user != null) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkLoginStatus(context);

    return CupertinoPageScaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Legacy Keeper",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.activeBlue,
              ),
            ),
            SizedBox(height: 20),
            CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
