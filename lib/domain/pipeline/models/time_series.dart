import 'dart:math' as math;

class TimeSeriesPoint {
  const TimeSeriesPoint({required this.timestamp, required this.value});

  final DateTime timestamp;
  final double value;
}

class MarketSeries {
  const MarketSeries(this.points);

  final List<TimeSeriesPoint> points;

  bool get isEmpty => points.isEmpty;

  int get length => points.length;

  DateTime? get start => isEmpty ? null : points.first.timestamp;

  DateTime? get end => isEmpty ? null : points.last.timestamp;

  double get mean =>
      isEmpty ? 0 : points.map((p) => p.value).reduce((a, b) => a + b) / points.length;

  double get variance {
    if (points.length < 2) return 0;
    final m = mean;
    final sum = points.fold<double>(0, (acc, p) => acc + math.pow(p.value - m, 2).toDouble());
    return sum / (points.length - 1);
  }

  double get standardDeviation => variance <= 0 ? 0 : math.sqrt(variance);

  MarketSeries subset(int start, [int? end]) {
    final sliced = points.sublist(start, end);
    return MarketSeries(sliced);
  }

  MarketSeries mapValues(double Function(TimeSeriesPoint) converter) {
    final mapped = points
        .map((point) => TimeSeriesPoint(timestamp: point.timestamp, value: converter(point)))
        .toList();
    return MarketSeries(mapped);
  }
}
