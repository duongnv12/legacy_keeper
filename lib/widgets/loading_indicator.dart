import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message; // Tùy chọn hiển thị thông điệp khi loading

  const LoadingIndicator({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Nền mờ đằng sau (overlay)
        Container(
          color: CupertinoColors.systemGrey.withOpacity(0.4),
        ),

        // Vòng loading và nội dung
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Vòng loading xoay
            const CupertinoActivityIndicator(
              radius: 20,
              color: AppConstants.primaryColor,
            ),
            const SizedBox(height: 20),

            // Thông báo loading (nếu có)
            if (message != null)
              Text(
                message!,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.black,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ],
    );
  }
}
