import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  // Lấy danh sách tất cả sự kiện (không ẩn)
  Future<List<Event>> getActiveEvents() async {
    try {
      final snapshot = await eventCollection.where('isHidden', isEqualTo: false).get();
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching active events: $e");
      rethrow;
    }
  }

  // Thêm sự kiện
  Future<void> addEvent(Event event) async {
    try {
      await eventCollection.add(event.toMap());
    } catch (e) {
      print("Error adding event: $e");
      rethrow;
    }
  }

  // Cập nhật sự kiện
  Future<void> updateEvent(String id, Event updatedEvent) async {
    try {
      await eventCollection.doc(id).update(updatedEvent.toMap());
    } catch (e) {
      print("Error updating event: $e");
      rethrow;
    }
  }

  // Ẩn sự kiện (chỉ thay đổi trạng thái isHidden)
  Future<void> hideEvent(String id) async {
    try {
      await eventCollection.doc(id).update({'isHidden': true});
    } catch (e) {
      print("Error hiding event: $e");
      rethrow;
    }
  }
}
