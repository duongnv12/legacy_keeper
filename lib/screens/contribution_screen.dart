// TODO Implement this library.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/contribution_provider.dart';
import '../models/contribution_model.dart';

class ContributionScreen extends StatefulWidget {
  const ContributionScreen({Key? key}) : super(key: key);

  @override
  _ContributionScreenState createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  final TextEditingController memberIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedStatus = "Chưa đóng"; // Trạng thái mặc định

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContributionProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Manage Contributions"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Form nhập liệu khoản thu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: memberIdController,
                    placeholder: "Enter member ID",
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    controller: amountController,
                    placeholder: "Enter amount (VNĐ)",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedStatus = ["Đã đóng", "Chưa đóng"][index];
                      });
                    },
                    children: const [
                      Text("Đã đóng"),
                      Text("Chưa đóng"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    child: const Text("Add Contribution"),
                    onPressed: () {
                      if (memberIdController.text.isNotEmpty &&
                          amountController.text.isNotEmpty) {
                        final contribution = Contribution(
                          id: '',
                          memberId: memberIdController.text,
                          amount: int.parse(amountController.text),
                          status: selectedStatus,
                          date: DateTime.now(),
                        );
                        provider.addContribution(contribution);

                        // Clear input fields
                        memberIdController.clear();
                        amountController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            // Danh sách các khoản thu
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      itemCount: provider.contributions.length,
                      itemBuilder: (context, index) {
                        final contribution = provider.contributions[index];
                        return ListTile(
                          title: Text("Member ID: ${contribution.memberId}"),
                          subtitle: Text("Amount: ${contribution.amount} VNĐ"),
                          trailing: Text(contribution.status),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
