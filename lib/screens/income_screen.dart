import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/family_member_model.dart';
import '../providers/annual_income_provider.dart';
import '../providers/family_member_provider.dart';
import '../models/annual_income_model.dart';
import '../utils/formatters.dart'; // Import tiện ích định dạng
import '../widgets/custom_table_cell.dart'; // Import widget tái sử dụng

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key, required this.year});

  final String year;

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  @override
  void initState() {
    super.initState();
    // Tự động tải danh sách thu nhập khi giao diện được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnnualIncomeProvider>(context, listen: false)
          .fetchAnnualIncomes(widget.year);
    });
  }

  // Hàm hiển thị form thiết lập khoản thu
  void _showSetQuotaForm(BuildContext context, List<FamilyMember> activeMembers) {
    final quotaController = TextEditingController();

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Set Annual Quota"),
        content: Column(
          children: [
            const SizedBox(height: 12),
            CupertinoTextField(
              controller: quotaController,
              placeholder: "Enter Quota (VND)",
              keyboardType: TextInputType.number,
              padding: const EdgeInsets.all(12),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              if (quotaController.text.isNotEmpty) {
                final incomeProvider = Provider.of<AnnualIncomeProvider>(
                  context,
                  listen: false,
                );

                for (var member in activeMembers) {
                  final income = AnnualIncome(
                    id: '', // Firestore sẽ tự động sinh ID
                    familyMemberId: member.id,
                    familyMemberName: member.name,
                    annualQuota: double.parse(quotaController.text),
                    paidAmount: 0,
                    status: "Chưa đóng",
                    year: widget.year,
                  );
                  await incomeProvider.addIncome(income);
                }

                Navigator.pop(context); // Đóng form sau khi lưu
              }
            },
            child: const Text("Set"),
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
        middle: Text("Annual Income - ${widget.year}"),
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
                        CustomTableCell(
                          text: "Member Name",
                          flex: 3,
                          isHeader: true,
                        ),
                        CustomTableCell(
                          text: "Quota",
                          flex: 2,
                          isHeader: true,
                        ),
                        CustomTableCell(
                          text: "Paid",
                          flex: 2,
                          isHeader: true,
                        ),
                        CustomTableCell(
                          text: "Status",
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
                            (i) => i.familyMemberId == member.id && i.year == widget.year,
                            orElse: () => AnnualIncome(
                              id: '',
                              familyMemberId: member.id,
                              familyMemberName: member.name,
                              annualQuota: 0,
                              paidAmount: 0,
                              status: "Chưa đóng",
                              year: widget.year,
                            ),
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                CustomTableCell(
                                  text: member.name,
                                  flex: 3,
                                ),
                                CustomTableCell(
                                  text: formatCurrency(income.annualQuota), // Định dạng tiền tệ
                                  flex: 2,
                                ),
                                CustomTableCell(
                                  text: formatCurrency(income.paidAmount), // Định dạng tiền tệ
                                  flex: 2,
                                ),
                                CustomTableCell(
                                  text: income.status,
                                  flex: 2,
                                  color: income.status == "Đã đóng"
                                      ? CupertinoColors.activeGreen
                                      : CupertinoColors.destructiveRed,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Nút thiết lập khoản thu
                    CupertinoButton.filled(
                      onPressed: () => _showSetQuotaForm(context, activeMembers),
                      child: const Text("Set Annual Quota"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}