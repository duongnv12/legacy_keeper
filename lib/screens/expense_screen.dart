import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legacy_keeper/models/annual_income_model.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/annual_income_provider.dart';
import '../providers/family_member_provider.dart';
import '../models/family_member_model.dart';
import '../models/expense_transaction_model.dart';
import '../utils/formatters.dart'; // Import tiện ích định dạng
import '../widgets/custom_table_cell.dart'; // Import widget tái sử dụng

class ExpenseScreen extends StatefulWidget {
  final String year;

  const ExpenseScreen({
    super.key,
    required this.year,
  });

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).fetchAllExpenses();
      Provider.of<AnnualIncomeProvider>(context, listen: false)
          .fetchAnnualIncomes(widget.year);
    });
  }

  // Hàm thêm khoản chi và đồng bộ với Income
  void _addExpenseAndSyncIncome(
      BuildContext context, FamilyMember member, double expenseAmount) async {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final incomeProvider = Provider.of<AnnualIncomeProvider>(context, listen: false);

    final expense = ExpenseTransaction(
      id: '', // Firestore tự động sinh ID
      familyMemberId: member.id,
      familyMemberName: member.name,
      title: "Annual Expense",
      amount: expenseAmount,
      category: "General",
      description: "Expense based on annual quota",
      date: DateTime.now(),
    );

    await expenseProvider.addExpenseAndUpdateIncome(expense);
    await incomeProvider.updateIncomeAfterExpense(member.id, widget.year, expenseAmount);

    // Hiển thị thông báo phê duyệt thành công
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Approved"),
        content: Text(
            "${member.name} has been approved for ${formatCurrency(expenseAmount)}."),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context); // Đóng thông báo
              setState(() {}); // Cập nhật giao diện
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final familyProvider = Provider.of<FamilyMemberProvider>(context);
    final incomeProvider = Provider.of<AnnualIncomeProvider>(context);

    // Lọc danh sách thành viên còn sống (deathDate == null)
    final activeMembers = familyProvider.familyMembers
        .where((member) => member.deathDate == null)
        .toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Manage Expenses - ${widget.year}"),
      ),
      child: SafeArea(
        child: familyProvider.isLoading || incomeProvider.isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Tiêu đề bảng
                    Row(
                      children: [
                        const CustomTableCell(
                          text: "Member Name",
                          flex: 3,
                          isHeader: true,
                        ),
                        const CustomTableCell(
                          text: "Expense Amount",
                          flex: 2,
                          isHeader: true,
                        ),
                        const CustomTableCell(
                          text: "Action",
                          flex: 2,
                          isHeader: true,
                        ),
                      ],
                    ),
                    const Divider(),

                    // Nội dung bảng
                    Expanded(
                      child: ListView.builder(
                        itemCount: activeMembers.length,
                        itemBuilder: (context, index) {
                          final member = activeMembers[index];
                          final income = incomeProvider.annualIncomes.firstWhere(
                            (income) =>
                                income.familyMemberId == member.id &&
                                income.year == widget.year,
                            orElse: () => AnnualIncome(
                              id: '',
                              familyMemberId: member.id,
                              familyMemberName: member.name,
                              annualQuota: 0.0,
                              paidAmount: 0.0,
                              status: "Chưa đóng",
                              year: widget.year,
                            ),
                          );

                          final quota = income.annualQuota;

                          // Kiểm tra nếu thành viên đã được Approve
                          final isApproved = income.status == "Đã đóng";

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CustomTableCell(
                                  text: member.name,
                                  flex: 3,
                                ),
                                CustomTableCell(
                                  text: formatCurrency(quota), // Định dạng tiền tệ
                                  flex: 2,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: CupertinoButton(
                                    color: isApproved
                                        ? CupertinoColors.systemGrey
                                        : CupertinoColors.activeGreen,
                                    padding: const EdgeInsets.all(8.0),
                                    onPressed: isApproved
                                        ? null
                                        : () {
                                            _addExpenseAndSyncIncome(
                                                context, member, quota);
                                          },
                                    child: Text(
                                      isApproved ? "Approved" : "Approve",
                                      style: TextStyle(
                                        color: isApproved
                                            ? CupertinoColors.black
                                            : CupertinoColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}