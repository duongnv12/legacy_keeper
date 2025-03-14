import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_keeper/screens/user_management_screen.dart';
import 'profile_screen.dart';
import '../services/firebase_auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) async {
    final authService = FirebaseAuthService();

    // Đăng xuất
    await authService.signOut();

    // Quay lại màn hình đăng nhập hoặc màn hình chính
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Settings"),
      ),
      child: SafeArea(
        child: Column(
            children: [
            // Hồ sơ cá nhân
            _buildSettingsOption(
              context,
              icon: CupertinoIcons.person,
              title: "Profile",
              onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const ProfileScreen()),
              );
              },
            ),
            const Divider(),

            // Quản lý người dùng
            _buildSettingsOption(
              context,
              icon: CupertinoIcons.group,
              title: "User Management",
              onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const UserManagementScreen()),
              );
              },
            ),
            const Divider(),

            // Đăng xuất
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
              onPressed: () async {
                _logout(context);
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text("Log Out"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Icon(icon, color: CupertinoColors.systemBlue),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18.0, color: CupertinoColors.black),
                ),
              ),
              const Icon(CupertinoIcons.forward, color: CupertinoColors.systemGrey),
            ],
          ),
        ),
      ),
    );
  }
}
