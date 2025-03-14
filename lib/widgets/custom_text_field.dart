import 'package:flutter/cupertino.dart';

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      padding: const EdgeInsets.all(16.0),
      keyboardType: keyboardType,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
