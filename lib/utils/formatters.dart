import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Định dạng ngày theo "dd/MM/yyyy"
String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

/// Định dạng giờ theo "HH:mm"
String formatTime(TimeOfDay time) {
  final String hour = time.hour.toString().padLeft(2, '0');
  final String minute = time.minute.toString().padLeft(2, '0');
  return "$hour:$minute";
}

/// Định dạng tiền tệ theo "VND 1,000,000"
String formatCurrency(double amount) {
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'VND',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}
