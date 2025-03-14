import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';

/// Widget for creating reusable custom dialogs
void showCustomDialog(
  BuildContext context, {
  required String title,
  required String content,
  VoidCallback? onConfirm, // Action to perform on confirm
  String confirmText = "OK", // Default confirm button text
  VoidCallback? onCancel, // Action to perform on cancel (optional)
  String cancelText = "Cancel", // Default cancel button text
  bool showCancelButton = false, // Show cancel button if true
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        // Cancel button (optional)
        if (showCancelButton)
          CupertinoDialogAction(
            isDefaultAction: false,
            onPressed: onCancel ?? () => Navigator.pop(context),
            child: Text(
              cancelText,
              style: const TextStyle(color: AppConstants.destructiveColor),
            ),
          ),

        // Confirm button
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onConfirm ?? () => Navigator.pop(context),
          child: Text(
            confirmText,
            style: const TextStyle(color: AppConstants.primaryColor),
          ),
        ),
      ],
    ),
  );
}
