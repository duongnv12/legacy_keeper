import 'package:flutter/cupertino.dart';
import 'package:legacy_keeper/widgets/custom_button.dart';
import 'package:legacy_keeper/widgets/custom_table_cell.dart';
import '../models/family_member_model.dart';
import 'add_family_member_screen.dart';

class FamilyMemberTableScreen extends StatelessWidget {
  final List<FamilyMember> familyMembers;

  const FamilyMemberTableScreen({super.key, required this.familyMembers});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Family Members"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Family Member List",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
              ),
              const SizedBox(height: 16),

              // Bảng danh sách thành viên
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(50.0),
                  1: FlexColumnWidth(),
                  2: FixedColumnWidth(90.0),
                  3: FixedColumnWidth(100.0),
                  4: FixedColumnWidth(100.0),
                  5: FixedColumnWidth(80.0),
                },
                border: TableBorder.all(
                  color: CupertinoColors.systemGrey,
                  width: 1.0,
                ),
                children: [
                  _buildTableHeader(),
                  ...familyMembers.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final FamilyMember member = entry.value;
                    return _buildTableRow(context, index, member);
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGrey5,
      ),
      children: const [
        CustomTableCell(
          text: "No.",
          flex: 1,
          isHeader: true,
        ),
        CustomTableCell(
          text: "Name",
          flex: 3,
          isHeader: true,
        ),
        CustomTableCell(
          text: "Gender",
          flex: 2,
          isHeader: true,
        ),
        CustomTableCell(
          text: "Birth Year",
          flex: 2,
          isHeader: true,
        ),
        CustomTableCell(
          text: "Status",
          flex: 2,
          isHeader: true,
        ),
        CustomTableCell(
          text: "Edit",
          flex: 1,
          isHeader: true,
        ),
      ],
    );
  }

  TableRow _buildTableRow(BuildContext context, int index, FamilyMember member) {
    return TableRow(
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? CupertinoColors.systemGrey6
            : CupertinoColors.white,
      ),
      children: [
        CustomTableCell(
          text: index.toString(),
          flex: 1,
        ),
        CustomTableCell(
          text: member.name,
          flex: 3,
        ),
        CustomTableCell(
          text: member.gender,
          flex: 2,
        ),
        CustomTableCell(
          text: member.birthDate,
          flex: 2,
        ),
        CustomTableCell(
          text: member.isActive ? "Active" : "Inactive",
          flex: 2,
          color: member.isActive
              ? CupertinoColors.activeGreen
              : CupertinoColors.destructiveRed,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            text: "Edit",
            color: CupertinoColors.activeBlue,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => AddFamilyMemberScreen(
                    member: member,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}