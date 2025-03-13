import 'package:flutter/cupertino.dart';

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText; // Add this parameter

  const CustomTextField({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.obscureText = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText, // Use the obscureText parameter
      obscuringCharacter: '•', // Customize the obscuring character
      padding: const EdgeInsets.all(16),
      style: const TextStyle(fontSize: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CupertinoColors.systemGrey4,
          width: 1.5,
        ),
      ),
    );
  }
}
