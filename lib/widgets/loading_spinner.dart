import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 15,
        color: AppColors.primaryColor,
      ),
    );
  }
}
