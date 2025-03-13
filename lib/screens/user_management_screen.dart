import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserService _userService = UserService();
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final fetchedUsers = await _userService.userCollection.get();
      setState(() {
        users = fetchedUsers.docs
            .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading users: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _userService.userCollection.doc(userId).delete();
      setState(() {
        users.removeWhere((user) => user.id == userId);
      });
      _showSuccessDialog("User deleted successfully!");
    } catch (e) {
      print("Error deleting user: $e");
      _showErrorDialog("Failed to delete user.");
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
              Navigator.pop(context);
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
        middle: Text("User Management"),
      ),
      child: SafeArea(
        child: isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text("Role: ${user.role}\nEmail: ${user.email}"),
                    trailing: CupertinoButton(
                      child: const Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed),
                      onPressed: () => _deleteUser(user.id),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
