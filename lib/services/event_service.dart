import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService {
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  // Lấy danh sách sự kiện
  Stream<List<Event>> getEvents() {
    return eventsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Thêm sự kiện mới
  Future<void> addEvent(Event event) async {
    try {
      await eventsCollection.add(event.toMap());
    } catch (e) {
      print("Error adding event: $e");
      rethrow;
    }
  }

  // Xóa sự kiện
  Future<void> deleteEvent(String id) async {
    try {
      await eventsCollection.doc(id).delete();
    } catch (e) {
      print("Error deleting event: $e");
      rethrow;
    }
  }
}
