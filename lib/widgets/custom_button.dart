import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: AppColors.primaryColor,
      disabledColor: AppColors.backgroundColor,
      onPressed: isLoading ? null : onPressed,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      borderRadius: BorderRadius.circular(10),
      child: isLoading
          ? const CupertinoActivityIndicator()
          : Text(
              text,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }
}
