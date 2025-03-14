import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color color; // Thêm tham số color

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color = CupertinoColors.activeBlue, // Giá trị mặc định là activeBlue
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: color, // Sử dụng màu được truyền vào
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const CupertinoActivityIndicator(color: CupertinoColors.white)
          : Text(
              text,
              style: const TextStyle(fontSize: 18, color: CupertinoColors.white),
            ),
    );
  }
}