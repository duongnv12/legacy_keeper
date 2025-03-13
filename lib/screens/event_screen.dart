import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = "Lễ Kỷ Niệm"; // Phân loại mặc định
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Manage Events"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Form nhập thông tin sự kiện
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CupertinoTextField(
                    controller: nameController,
                    placeholder: "Enter event name",
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    controller: locationController,
                    placeholder: "Enter location",
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    controller: costController,
                    placeholder: "Enter cost (VNĐ)",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    controller: descriptionController,
                    placeholder: "Enter description",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  CupertinoButton(
                    child: const Text("Select Date"),
                    onPressed: () async {
                      DateTime? pickedDate = await showCupertinoModalPopup(
                        context: context,
                        builder: (context) => SizedBox(
                          height: 300,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.dateAndTime,
                            initialDateTime: selectedDate,
                            onDateTimeChanged: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                          ),
                        ),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    child: const Text("Add Event"),
                    onPressed: () {
                      final event = Event(
                        id: '',
                        name: nameController.text,
                        category: selectedCategory,
                        date: selectedDate,
                        location: locationController.text,
                        cost: int.parse(costController.text),
                        description: descriptionController.text,
                      );
                      provider.addEvent(event);

                      // Clear inputs
                      nameController.clear();
                      locationController.clear();
                      costController.clear();
                      descriptionController.clear();
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            // Hiển thị danh sách sự kiện
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : ListView.builder(
                      itemCount: provider.events.length,
                      itemBuilder: (context, index) {
                        final event = provider.events[index];
                        return ListTile(
                          title: Text(event.name),
                          subtitle: Text("Date: ${event.date}"),
                          trailing: Text(event.category),
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
