import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import '../widgets/custom_dialog.dart';
import '../utils/formatters.dart';
import 'add_event_screen.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchActiveEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Event Management"),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Hiển thị danh sách sự kiện
            if (eventProvider.isLoading)
              const Center(child: CupertinoActivityIndicator())
            else if (eventProvider.events.isEmpty)
              const Center(
                child: Text(
                  "No events available.\nPress the + button to add a new event.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              )
            else
              ListView.builder(
                itemCount: eventProvider.events.length,
                itemBuilder: (context, index) {
                  final event = eventProvider.events[index];
                  return _buildEventItem(context, eventProvider, event);
                },
              ),

            // Nút "+" thêm sự kiện
            Positioned(
              bottom: 20,
              right: 20,
              child: CupertinoButton(
                color: CupertinoColors.activeBlue,
                padding: const EdgeInsets.all(16.0),
                borderRadius: BorderRadius.circular(30),
                child: const Icon(CupertinoIcons.add, color: CupertinoColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const AddEventScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, EventProvider provider, Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () => _showEventDetail(context, event),
        child: Container(
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Avatar hoặc Icon
                CircleAvatar(
                  radius: 24,
                  backgroundColor: CupertinoColors.systemGrey4,
                  child: const Icon(
                    CupertinoIcons.calendar,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(width: 16),
                // Thông tin sự kiện
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Date: ${formatDate(event.date)}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      Text(
                        "Category: ${event.category}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Nút "Hide"
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: CupertinoColors.destructiveRed,
                  child: const Icon(CupertinoIcons.delete, color: CupertinoColors.white),
                  onPressed: () => _hideEvent(provider, event),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hideEvent(EventProvider eventProvider, Event event) async {
    await eventProvider.hideEvent(event.id);

    // Hiển thị thông báo sau khi sự kiện được ẩn
    showCustomDialog(
      context,
      title: "Event Hidden",
      content: "${event.title} has been successfully hidden.",
      onConfirm: () => Navigator.pop(context),
    );
  }

  void _showEventDetail(BuildContext context, Event event) {
    showCustomDialog(
      context,
      title: event.title,
      content: "Category: ${event.category}\n"
          "Date: ${formatDate(event.date)}\n"
          "Time: ${formatTime(event.time)}\n"
          "Location: ${event.location}\n"
          "Cost: ${formatCurrency(event.cost)}\n\n" 
          "Description:\n${event.description}",
      onConfirm: () => Navigator.pop(context),
    );
  }
}
