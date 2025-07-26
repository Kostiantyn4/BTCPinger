import 'package:intl/intl.dart';

// Helper functions for the application
class AppHelpers {
  // Format price with currency
  static String formatPrice(double price, {String currency = 'USD'}) {
    final formatter = NumberFormat.currency(
      symbol: currency,
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  // Calculate percentage change between two values
  static double calculatePercentageChange(double oldValue, double newValue) {
    if (oldValue == 0) return 0;
    return ((newValue - oldValue) / oldValue) * 100;
  }

  // Format date time for display
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
