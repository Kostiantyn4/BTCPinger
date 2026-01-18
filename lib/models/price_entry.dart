import 'package:equatable/equatable.dart';

/// Domain model representing a Bitcoin price point in a specific currency.
class PriceEntry extends Equatable {
  const PriceEntry({
    required this.timestamp,
    required this.price,
    this.currency = 'USD',
  });

  final DateTime timestamp;
  final double price;
  final String currency;

  PriceEntry copyWith({
    DateTime? timestamp,
    double? price,
    String? currency,
  }) {
    return PriceEntry(
      timestamp: timestamp ?? this.timestamp,
      price: price ?? this.price,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'price': price,
        'currency': currency,
      };

  factory PriceEntry.fromJson(Map<String, dynamic> json) {
    return PriceEntry(
      timestamp: DateTime.parse(json['timestamp'] as String),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
    );
  }

  @override
  List<Object?> get props => [timestamp, price, currency];
}
