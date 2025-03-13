import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({Key? key}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;

    if (currentUser != null) {
      nameController.text = currentUser.name;
      emailController.text = currentUser.email;
    }
  }

  Future<void> _updateUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      _showErrorDialog("Please fill in all fields.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final updatedUser = User(
      id: userProvider.currentUser!.id, // Giữ nguyên ID
      name: nameController.text,
      email: emailController.text,
      avatarUrl: userProvider.currentUser!.avatarUrl, // Giữ nguyên avatar
      role: userProvider.currentUser!.role, // Giữ nguyên vai trò
    );

    await userProvider.saveUser(updatedUser);

    setState(() {
      isLoading = false;
    });

    _showSuccessDialog("Information updated successfully!");
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
              Navigator.pop(context); // Đóng thông báo
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
        middle: Text("Personal Information"),
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
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton.filled(
                      child: const Text("Update"),
                      onPressed: _updateUserInfo,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
