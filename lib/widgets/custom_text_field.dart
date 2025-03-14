import 'package:flutter/cupertino.dart';

class CustomTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? errorText; // Bổ sung hiển thị lỗi
  final Function(String)? onChanged; // Bổ sung callback khi dữ liệu thay đổi
  final bool showClearButton; // Hiển thị nút "Clear" hay không
  final int? maxLines;

  const CustomTextField({
    Key? key,
    required this.placeholder,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
    this.showClearButton = true,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          obscureText: obscureText,
          padding: const EdgeInsets.all(16.0),
          keyboardType: keyboardType,
          onChanged: onChanged,
          clearButtonMode:
              showClearButton ? OverlayVisibilityMode.editing : OverlayVisibilityMode.never,
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey5,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        if (errorText != null) // Hiển thị thông báo lỗi nếu có
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: CupertinoColors.destructiveRed,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
