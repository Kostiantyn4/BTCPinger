import 'time_series.dart';

class SmoothedSeries {
  const SmoothedSeries({
    required this.raw,
    required this.smoothed,
    required this.estimatedLag,
  });

  final MarketSeries raw;
  final MarketSeries smoothed;
  final Duration estimatedLag;
}
