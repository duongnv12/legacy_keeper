import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family_member_model.dart';
import '../services/family_member_service.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({Key? key}) : super(key: key);

  @override
  _AddFamilyMemberScreenState createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  String? selectedParentId; // ID cha/mẹ được chọn
  List<Map<String, String>> parentsList = []; // Danh sách cha/mẹ từ Firestore

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchParents(); // Lấy danh sách cha/mẹ từ Firestore
  }

  Future<void> _fetchParents() async {
    try {
      // Lấy dữ liệu từ Firestore (bao gồm Ông Tổ và các thành viên hiện tại)
      final ancestorSnapshot = await FirebaseFirestore.instance
          .collection('ancestors') // Lấy Ông Tổ
          .get();

      final familyMembersSnapshot = await FirebaseFirestore.instance
          .collection('family_members') // Lấy các thành viên hiện tại
          .get();

      // Danh sách cha/mẹ (Ông Tổ + các thành viên)
      final allParents = [
        ...ancestorSnapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc.data()['name'] as String,
            }),
        ...familyMembersSnapshot.docs.map((doc) => {
              'id': doc.id,
              'name': doc.data()['name'] as String,
            }),
      ];

      setState(() {
        parentsList = allParents;
        selectedParentId = allParents.isNotEmpty ? allParents.first['id'] : null; // Giá trị mặc định
      });
    } catch (e) {
      print("Error fetching parents: $e");
    }
  }

  void _saveMember() async {
    final name = nameController.text.trim();
    final birthYear = birthYearController.text.trim();

    if (name.isEmpty || birthYear.isEmpty) {
      _showErrorDialog("Name and Birth Year cannot be empty.");
      return;
    }

    final member = FamilyMember(
      id: '',
      name: name,
      birthYear: birthYear,
      parentId: selectedParentId,
      createdAt: DateTime.now(),
    );

    try {
      await FamilyMemberService().addFamilyMember(member);
      Navigator.pop(context); // Quay lại sau khi thêm thành viên
    } catch (e) {
      _showErrorDialog("Failed to save family member: $e");
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Add Family Member"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoTextField(
                placeholder: "Name",
                controller: nameController,
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                placeholder: "Birth Year",
                controller: birthYearController,
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Parent",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              parentsList.isEmpty
                  ? const CupertinoActivityIndicator() // Hiển thị trong khi tải dữ liệu
                  : CupertinoPicker(
                      itemExtent: 32.0,
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedParentId = parentsList[index]['id'];
                        });
                      },
                      children: parentsList
                          .map((parent) => Text(parent['name']!))
                          .toList(),
                    ),
              const SizedBox(height: 40),
              CupertinoButton.filled(
                child: isLoading
                    ? const CupertinoActivityIndicator()
                    : const Text("Save"),
                onPressed: isLoading ? null : _saveMember,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
