import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dialog.dart';
import '../utils/formatters.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  String _category = "Other";
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Add New Event"),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề sự kiện
              const Text("Title:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _titleController,
                placeholder: "Event Title",
              ),
              const SizedBox(height: 16),

              // Địa điểm sự kiện
              const Text("Location:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _locationController,
                placeholder: "Location",
              ),
              const SizedBox(height: 16),

              // Chi phí
              const Text("Cost:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _costController,
                placeholder: "Cost (VND)",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Mô tả sự kiện
              const Text("Description:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _descriptionController,
                placeholder: "Description",
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Danh mục sự kiện
              const Text("Category:", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              CupertinoSegmentedControl<String>(
                children: const {
                  "Anniversary": Text("Anniversary"),
                  "Meeting": Text("Meeting"),
                  "Commemoration": Text("Commemoration"),
                  "Other": Text("Other"),
                },
                groupValue: _category,
                onValueChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Chọn ngày
              CustomButton(
                text: "Select Date: ${formatDate(_selectedDate)}",
                onPressed: _selectDate,
              ),
              const SizedBox(height: 16),

              // Chọn giờ
              CustomButton(
                text: "Select Time: ${formatTime(_selectedTime)}",
                onPressed: _selectTime,
              ),
              const SizedBox(height: 16),

              // Nút thêm sự kiện
              CustomButton(
                text: "Add Event",
                onPressed: () => _addEvent(eventProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: _selectedDate,
          onDateTimeChanged: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      ),
    );
  }

  void _selectTime() async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.time,
          initialDateTime: DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            _selectedTime.hour,
            _selectedTime.minute,
          ),
          onDateTimeChanged: (dateTime) {
            setState(() {
              _selectedTime = TimeOfDay.fromDateTime(dateTime);
            });
          },
        ),
      ),
    );
  }

  void _addEvent(EventProvider eventProvider) async {
    // Kiểm tra dữ liệu đầu vào
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _costController.text.isEmpty) {
      showCustomDialog(
        context,
        title: "Missing Information",
        content: "Please fill in all required fields.",
        onConfirm: () => Navigator.pop(context),
      );
      return;
    }

    // Tạo sự kiện mới
    final newEvent = Event(
      id: '', // Firestore sẽ tự sinh ID
      title: _titleController.text,
      category: _category,
      date: _selectedDate,
      time: _selectedTime,
      location: _locationController.text,
      cost: double.tryParse(_costController.text) ?? 0.0,
      description: _descriptionController.text,
      isHidden: false,
    );

    // Thêm sự kiện qua Provider
    await eventProvider.addEvent(newEvent);

    // Hiển thị thông báo thành công
    showCustomDialog(
      context,
      title: "Event Added",
      content: "The event has been successfully added.",
      onConfirm: () {
        Navigator.pop(context); // Đóng dialog
        Navigator.pop(context); // Quay lại màn hình trước
      },
    );
  }
}
