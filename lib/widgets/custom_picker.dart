import 'package:flutter/cupertino.dart';
import '../utils/constants.dart';

class CustomPicker extends StatelessWidget {
  final List<String> options;
  final String selectedItem;
  final ValueChanged<int> onSelected;

  const CustomPicker({
    super.key,
    required this.options,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => Container(
            height: 250,
            color: CupertinoColors.systemBackground,
            child: CupertinoPicker(
              itemExtent: 32.0,
              onSelectedItemChanged: onSelected,
              children: options.map((option) => Text(option)).toList(),
            ),
          ),
        );
      },
      child: Text(
        selectedItem,
        style: const TextStyle(fontSize: 16, color: AppConstants.primaryColor),
      ),
    );
  }
}
