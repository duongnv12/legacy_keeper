import 'package:flutter/foundation.dart';
import '../models/annual_fee_model.dart';
import '../services/annual_fee_service.dart';

class AnnualFeeProvider with ChangeNotifier {
  final AnnualFeeService _service = AnnualFeeService();
  List<AnnualFee> _fees = [];
  bool _isLoading = false;

  List<AnnualFee> get fees => _fees;
  bool get isLoading => _isLoading;

  Future<void> fetchFees() async {
    _isLoading = true;
    notifyListeners();

    try {
      _service.getAnnualFees().listen((fetchedFees) {
        _fees = fetchedFees;
        notifyListeners();
      });
    } catch (e) {
      print("Error fetching annual fees: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFee(AnnualFee fee) async {
    await _service.addAnnualFee(fee);
    fetchFees(); // Làm mới dữ liệu
  }
}
