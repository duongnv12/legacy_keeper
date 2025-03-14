import 'package:flutter/cupertino.dart';
import '../models/family_member_model.dart';
import 'add_family_member_screen.dart';

class FamilyMemberTableScreen extends StatelessWidget {
  final List<FamilyMember> familyMembers; // Danh sách thành viên được truyền vào

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
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(50.0), // Số Thứ Tự
                  1: FlexColumnWidth(), // Tên
                  2: FixedColumnWidth(90.0), // Giới Tính
                  3: FixedColumnWidth(100.0), // Năm Sinh
                  4: FixedColumnWidth(100.0), // Trạng Thái
                  5: FixedColumnWidth(80.0), // Nút Chỉnh Sửa
                },
                border: TableBorder.all(
                  color: CupertinoColors.systemGrey,
                  width: 1.0,
                ),
                children: [
                  // Hàng Tiêu Đề
                  TableRow(
                    decoration: const BoxDecoration(
                      color: CupertinoColors.systemGrey5,
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "No.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Birth Year",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Status",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  // Hàng Dữ Liệu
                  ...familyMembers.asMap().entries.map((entry) {
                    final index = entry.key + 1; // Số Thứ Tự
                    final FamilyMember member = entry.value;
                    return TableRow(
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? CupertinoColors.systemGrey6
                            : CupertinoColors.white,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            index.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            member.name,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            member.gender,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            member.birthDate,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            member.isActive ? "Active" : "Inactive",
                            style: TextStyle(
                              color: member.isActive
                                  ? CupertinoColors.activeGreen
                                  : CupertinoColors.destructiveRed,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: CupertinoColors.activeBlue,
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => AddFamilyMemberScreen(
                                    member: member, // Truyền thông tin thành viên để chỉnh sửa
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
