import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
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
