import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/annual_fee_provider.dart';
import '../models/annual_fee_model.dart';

class AnnualFeeScreen extends StatefulWidget {
  const AnnualFeeScreen({Key? key}) : super(key: key);

  @override
  _AnnualFeeScreenState createState() => _AnnualFeeScreenState();
}

class _AnnualFeeScreenState extends State<AnnualFeeScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnualFeeProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Annual Fee Setup"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Form để thêm định mức hàng năm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: amountController,
                    placeholder: "Enter amount (VNĐ)",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    controller: yearController,
                    placeholder: "Enter year",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    child: const Text("Add Annual Fee"),
                    onPressed: () {
                      final fee = AnnualFee(
                        id: '',
                        amount: int.parse(amountController.text),
                        year: int.parse(yearController.text),
                      );
                      provider.addFee(fee);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            // Hiển thị danh sách định mức hàng năm
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      itemCount: provider.fees.length,
                      itemBuilder: (context, index) {
                        final fee = provider.fees[index];
                        return ListTile(
                          title: Text("Year: ${fee.year}"),
                          subtitle: Text("Amount: ${fee.amount} VNĐ"),
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
