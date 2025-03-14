import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  bool isLoading = false; // Trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Lấy danh sách người dùng khi mở màn hình
  }

  Future<void> _fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers(); // Lấy danh sách từ UserProvider
    setState(() {
      isLoading = false;
    });
  }

  void _toggleUserActiveState(User user) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final newState = !user.isActive;

    setState(() {
      isLoading = true;
    });

    try {
      await userProvider.setUserActiveState(user.id, newState);
      _showSuccessDialog(
        newState ? "User activated successfully." : "User deactivated successfully.",
      );
    } catch (e) {
      _showErrorDialog("Failed to update user state. Please try again.");
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
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final users = userProvider.users;

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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey.withOpacity(0.5),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hiển thị thông tin người dùng
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Role: ${user.role}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Status: ${user.isActive ? "Active" : "Inactive"}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: user.isActive
                                        ? CupertinoColors.activeGreen
                                        : CupertinoColors.destructiveRed,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Nút thay đổi trạng thái Active/Inactive
                          CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            color: user.isActive
                                ? CupertinoColors.destructiveRed
                                : CupertinoColors.activeGreen,
                            onPressed: () => _toggleUserActiveState(user),
                            child: Text(user.isActive ? "Deactivate" : "Activate"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
