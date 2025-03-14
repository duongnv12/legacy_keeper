import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family_member_model.dart';
import '../services/family_member_service.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  final FamilyMember? member; // Thành viên truyền vào (nếu có để chỉnh sửa)

  const AddFamilyMemberScreen({super.key, this.member});

  @override
  _AddFamilyMemberScreenState createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedParentId; // ID của cha/mẹ được chọn
  String selectedGender = "Male"; // Giới tính mặc định
  List<Map<String, String>> parentsList = []; // Danh sách cha/mẹ từ Firestore

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchParents();
    if (widget.member != null) {
      _initializeForEditing(); // Khởi tạo giá trị khi chỉnh sửa
    }
  }

  void _initializeForEditing() {
    final member = widget.member!;
    nameController.text = member.name;
    birthYearController.text = member.birthDate;
    phoneNumberController.text = member.phoneNumber ?? '';
    emailController.text = member.email ?? '';
    selectedGender = member.gender;
    selectedParentId = member.parentId;
  }

  Future<void> _fetchParents() async {
    try {
      final ancestorSnapshot = await FirebaseFirestore.instance
          .collection('ancestors')
          .get();

      final familyMembersSnapshot = await FirebaseFirestore.instance
          .collection('family_members')
          .get();

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
        selectedParentId ??= allParents.isNotEmpty ? allParents.first['id'] : null;
      });
    } catch (e) {
      print("Error fetching parents: $e");
    }
  }

  void _saveMember() async {
    final name = nameController.text.trim();
    final birthYear = birthYearController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || birthYear.isEmpty) {
      _showErrorDialog("Name and Birth Year cannot be empty.");
      return;
    }

    final member = FamilyMember(
      id: widget.member?.id ?? '', // Sử dụng ID nếu chỉnh sửa, hoặc để trống nếu thêm mới
      name: name,
      birthDate: birthYear,
      gender: selectedGender,
      phoneNumber: phoneNumber.isNotEmpty ? phoneNumber : null,
      email: email.isNotEmpty ? email : null,
      parentId: selectedParentId,
      isActive: widget.member?.isActive ?? true, // Giữ nguyên trạng thái nếu chỉnh sửa
      createdAt: widget.member?.createdAt ?? DateTime.now(), // Dùng createdAt cũ nếu chỉnh sửa
    );

    try {
      setState(() {
        isLoading = true;
      });
      if (widget.member != null) {
        // Chỉnh sửa
        await FamilyMemberService().updateFamilyMember(member.id, member.toMap());
      } else {
        // Thêm mới
        await FamilyMemberService().addFamilyMember(member);
      }
      Navigator.pop(context, member); // Trả về thành viên đã thêm hoặc chỉnh sửa
    } catch (e) {
      _showErrorDialog("Failed to save family member: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
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
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.member == null ? "Add Family Member" : "Edit Family Member"),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoTextField(
                placeholder: "Full Name",
                controller: nameController,
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                placeholder: "Birth Year (e.g., 1990)",
                controller: birthYearController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              const Text(
                "Select Gender",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              CupertinoSegmentedControl<String>(
                children: const {
                  "Male": Text("Male"),
                  "Female": Text("Female"),
                },
                groupValue: selectedGender,
                onValueChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              CupertinoTextField(
                placeholder: "Phone Number (Optional)",
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                placeholder: "Email Address (Optional)",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              const Text(
                "Select Parent",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              parentsList.isEmpty
                  ? const CupertinoActivityIndicator()
                  : CupertinoPicker(
                      itemExtent: 32.0,
                      scrollController: FixedExtentScrollController(
                        initialItem: parentsList.indexWhere((parent) =>
                            parent['id'] == selectedParentId),
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
                onPressed: isLoading ? null : _saveMember,
                child: isLoading
                    ? const CupertinoActivityIndicator()
                    : Text(widget.member == null ? "Save Member" : "Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
