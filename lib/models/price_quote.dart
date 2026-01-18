import 'package:equatable/equatable.dart';

/// Represents the latest Bitcoin price in multiple currencies.
class PriceQuote extends Equatable {
  const PriceQuote({
    required this.timestamp,
    required this.usd,
    required this.uah,
  });

  final DateTime timestamp;
  final double usd;
  final double uah;

  @override
  List<Object?> get props => [timestamp, usd, uah];
}
