// Model for storing Bitcoin price data points
class PriceEntry {
  final DateTime timestamp;
  final double price;
  final String currency;

  const PriceEntry({
    required this.timestamp,
    required this.price,
    this.currency = 'USD',
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'price': price,
    'currency': currency,
  };

  // Create from JSON for database retrieval
  factory PriceEntry.fromJson(Map<String, dynamic> json) {
    return PriceEntry(
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: json['price'] as double,
      currency: json['currency'] as String,
    );
  }
}
