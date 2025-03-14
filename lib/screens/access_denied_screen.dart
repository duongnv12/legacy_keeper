import 'package:flutter/cupertino.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Access Denied"),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.lock,
                size: 100,
                color: CupertinoColors.destructiveRed,
              ),
              const SizedBox(height: 20),
              const Text(
                "You don't have permission to access this page.",
                style: TextStyle(fontSize: 18, color: CupertinoColors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                child: const Text("Back to Login"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
