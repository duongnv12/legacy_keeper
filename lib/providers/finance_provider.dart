import 'package:flutter/foundation.dart';
import '../models/finance_model.dart';
import '../services/finance_service.dart';

class FinanceProvider with ChangeNotifier {
  final FinanceService _service = FinanceService();
  List<FinanceEntry> _entries = [];
  bool _isLoading = false;

  List<FinanceEntry> get entries => _entries;
  bool get isLoading => _isLoading;

  Future<void> fetchEntries() async {
    _isLoading = true;
    notifyListeners();

    try {
      _service.getFinanceEntries().listen((fetchedEntries) {
        _entries = fetchedEntries;
        notifyListeners();
      });
    } catch (e) {
      print("Error fetching finance entries: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEntry(FinanceEntry entry) async {
    await _service.addFinanceEntry(entry);
    fetchEntries(); // Refresh data
  }
}
