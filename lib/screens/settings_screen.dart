import 'package:flutter/cupertino.dart';
import 'personal_info_screen.dart';
import 'user_management_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Settings"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Personal Information
            _buildSettingsOption(
              context,
              icon: CupertinoIcons.person,
              title: "Personal Information",
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const PersonalInfoScreen()),
                );
              },
            ),
            // User Management
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
          ],
        ),
      ),
    );
  }

  // Helper method to build Cupertino-style settings options
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
