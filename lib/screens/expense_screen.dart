import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense_model.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String selectedCategory = "Sự kiện"; // Danh mục mặc định

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Manage Expenses"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Form nhập liệu khoản chi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: descriptionController,
                    placeholder: "Enter description",
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
                        selectedCategory = ["Sự kiện", "Cơ sở vật chất", "Khác"][index];
                      });
                    },
                    children: const [
                      Text("Sự kiện"),
                      Text("Cơ sở vật chất"),
                      Text("Khác"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    child: const Text("Add Expense"),
                    onPressed: () {
                      final expense = Expense(
                        id: '',
                        description: descriptionController.text,
                        category: selectedCategory,
                        amount: int.parse(amountController.text),
                        date: DateTime.now(),
                      );
                      provider.addExpense(expense);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            // Danh sách các khoản chi
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      itemCount: provider.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = provider.expenses[index];
                        return ListTile(
                          title: Text(expense.description),
                          subtitle: Text("Amount: ${expense.amount} VNĐ"),
                          trailing: Text(expense.category),
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
