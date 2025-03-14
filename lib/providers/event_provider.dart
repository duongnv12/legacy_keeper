import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _service = EventService();
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;

  // Lấy danh sách sự kiện không ẩn
  Future<void> fetchActiveEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events = await _service.getActiveEvents();
    } catch (e) {
      print("Error fetching active events: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm sự kiện mới
  Future<void> addEvent(Event event) async {
    try {
      await _service.addEvent(event);
      _events.add(event);
      notifyListeners();
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  // Cập nhật sự kiện
  Future<void> updateEvent(String id, Event updatedEvent) async {
    try {
      await _service.updateEvent(id, updatedEvent);
      final index = _events.indexWhere((e) => e.id == id);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating event: $e");
    }
  }

  // Ẩn sự kiện
  Future<void> hideEvent(String id) async {
    try {
      await _service.hideEvent(id);
      _events.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      print("Error hiding event: $e");
    }
  }
}
