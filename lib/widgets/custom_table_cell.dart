import 'package:flutter/cupertino.dart';

class CustomTableCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool isHeader;
  final TextAlign textAlign;
  final Color? color;

  const CustomTableCell({
    super.key,
    required this.text,
    required this.flex,
    this.isHeader = false,
    this.textAlign = TextAlign.center,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: color,
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: isHeader ? 16 : 14,
            color: CupertinoColors.black,
          ),
        ),
      ),
    );
  }
}