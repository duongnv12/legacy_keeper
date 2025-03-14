import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'financial_report_screen.dart';
import 'income_screen.dart';
import 'expense_screen.dart';

class FinancialManagementScreen extends StatefulWidget {
  const FinancialManagementScreen({super.key});

  @override
  _FinancialManagementScreenState createState() =>
      _FinancialManagementScreenState();
}

class _FinancialManagementScreenState extends State<FinancialManagementScreen> {
  int _selectedIndex = 0; // Chỉ số màn hình được chọn
  String selectedYear = DateTime.now().year.toString(); // Năm mặc định

  // Danh sách các màn hình, truyền `selectedYear` vào từng màn hình
  List<Widget> get _screens => [
        FinancialReportScreen(year: selectedYear), // Báo cáo tài chính tổng hợp
        IncomeScreen(year: selectedYear),         // Quản lý thu nhập
        ExpenseScreen(year: selectedYear),        // Quản lý chi phí
      ];

  final Map<int, String> _titles = {
    0: "Financial Report",
    1: "Manage Income",
    2: "Manage Expenses",
  };

  // Hàm hiển thị chọn năm
  void _showYearPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 200,
        color: CupertinoColors.systemBackground,
        child: CupertinoPicker(
          scrollController: FixedExtentScrollController(
            initialItem: DateTime.now().year - int.parse(selectedYear),
          ),
          itemExtent: 32,
          onSelectedItemChanged: (index) {
            setState(() {
              selectedYear = (DateTime.now().year - index).toString(); // Cập nhật năm
            });
          },
          children: List<Widget>.generate(10, (index) {
            final year = DateTime.now().year - index;
            return Center(child: Text(year.toString()));
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("${_titles[_selectedIndex]} ($selectedYear)"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showYearPicker(context), // Hiển thị trình chọn năm
          child: const Icon(CupertinoIcons.calendar, size: 28),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Phần chọn chế độ: Báo cáo, Thu, Chi
            CupertinoSegmentedControl<int>(
              groupValue: _selectedIndex,
              children: const {
                0: Text("Report"),
                1: Text("Income"),
                2: Text("Expenses"),
              },
              onValueChanged: (value) {
                setState(() {
                  _selectedIndex = value; // Cập nhật màn hình khi chọn
                });
              },
            ),
            const Divider(),
            Expanded(
              child: _screens[_selectedIndex], // Hiển thị màn hình tương ứng
            ),
          ],
        ),
      ),
    );
  }
}
