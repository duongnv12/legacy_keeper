import 'package:flutter/cupertino.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../services/ancestor_service.dart';
import '../models/ancestor_model.dart';

class AddAncestorScreen extends StatefulWidget {
  const AddAncestorScreen({Key? key}) : super(key: key);

  @override
  _AddAncestorScreenState createState() => _AddAncestorScreenState();
}

class _AddAncestorScreenState extends State<AddAncestorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;

  int selectedBirthYear = DateTime.now().year - 100; // Giá trị mặc định
  int selectedDeathYear = DateTime.now().year; // Giá trị mặc định

  // Danh sách năm (cách khoảng 300 năm)
  List<int> getYearRange() {
    final currentYear = DateTime.now().year;
    return List.generate(300, (index) => currentYear - index);
  }

  void _saveAncestor() async {
    final name = nameController.text.trim();
    final notes = notesController.text.trim();

    if (name.isEmpty) {
      _showErrorDialog("Name cannot be empty.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final ancestor = Ancestor(
      id: '',
      name: name,
      birthDate: selectedBirthYear.toString(),
      deathDate: selectedDeathYear > selectedBirthYear
          ? selectedDeathYear.toString()
          : null, // Năm mất có thể null nếu không rõ
      notes: notes.isNotEmpty ? notes : null,
      createdAt: DateTime.now(),
    );

    try {
      await AncestorService().addAncestor(ancestor);
      setState(() {
        isLoading = false;
      });
      _showSuccessDialog("Ancestor information saved successfully!");
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog("Failed to save ancestor. Please try again.");
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

  void _showSuccessDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context); // Quay về màn hình trước
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Add Ancestor"),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField(
                  placeholder: "Full Name",
                  controller: nameController,
                ),
                const SizedBox(height: 20),

                // Picker cho năm sinh
                const Text(
                  "Birth Year",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CupertinoButton(
                  child: Text(selectedBirthYear.toString()),
                  onPressed: () {
                    _showYearPicker(
                      context: context,
                      initialYear: selectedBirthYear,
                      onYearSelected: (year) {
                        setState(() {
                          selectedBirthYear = year;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Picker cho năm mất
                const Text(
                  "Death Year",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                CupertinoButton(
                  child: Text(selectedDeathYear.toString()),
                  onPressed: () {
                    _showYearPicker(
                      context: context,
                      initialYear: selectedDeathYear,
                      onYearSelected: (year) {
                        setState(() {
                          selectedDeathYear = year;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  placeholder: "Notes (Optional)",
                  controller: notesController,
                ),
                const SizedBox(height: 40),

                CustomButton(
                  text: "Save",
                  onPressed: isLoading
                      ? () {}
                      : () {
                          _saveAncestor();
                        },
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showYearPicker({
    required BuildContext context,
    required int initialYear,
    required Function(int) onYearSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => SizedBox(
        height: 250,
        child: CupertinoPicker(
          itemExtent: 32.0,
          scrollController: FixedExtentScrollController(
            initialItem: getYearRange().indexOf(initialYear),
          ),
          onSelectedItemChanged: (index) {
            onYearSelected(getYearRange()[index]);
          },
          children: getYearRange().map((year) => Text(year.toString())).toList(),
        ),
      ),
    );
  }
}
