import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _service = EventService();
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _service.getEvents().listen((fetchedEvents) {
        _events = fetchedEvents;
        notifyListeners();
      });
    } catch (e) {
      print("Error fetching events: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    await _service.addEvent(event);
    fetchEvents(); // Làm mới danh sách sự kiện
  }

  Future<void> deleteEvent(String id) async {
    await _service.deleteEvent(id);
    _events.removeWhere((event) => event.id == id);
    notifyListeners(); // Cập nhật giao diện
  }
}
