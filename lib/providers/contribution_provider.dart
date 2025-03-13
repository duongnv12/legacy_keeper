import 'package:flutter/foundation.dart';
import '../models/contribution_model.dart';
import '../services/contribution_service.dart';

class ContributionProvider with ChangeNotifier {
  final ContributionService _service = ContributionService();
  List<Contribution> _contributions = [];
  bool _isLoading = false;

  List<Contribution> get contributions => _contributions;
  bool get isLoading => _isLoading;

  // Lấy dữ liệu các khoản thu
  Future<void> fetchContributions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _service.getContributions().listen((fetchedContributions) {
        _contributions = fetchedContributions;
        notifyListeners();
      });
    } catch (e) {
      print("Error fetching contributions: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // Thêm khoản thu mới
  Future<void> addContribution(Contribution contribution) async {
    await _service.addContribution(contribution);
    fetchContributions(); // Làm mới dữ liệu sau khi thêm
  }

  // Xóa khoản thu
  Future<void> deleteContribution(String id) async {
    await _service.deleteContribution(id);
    _contributions.removeWhere((contribution) => contribution.id == id);
    notifyListeners(); // Cập nhật giao diện
  }
}
