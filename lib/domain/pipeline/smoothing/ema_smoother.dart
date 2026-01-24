import '../models/smoothed_series.dart';
import '../models/time_series.dart';
import 'signal_smoother.dart';

class EmaSmoother implements SignalSmoother {
  EmaSmoother({required this.window});

  final int window;

  @override
  SmoothedSeries smooth(MarketSeries series) {
    if (series.isEmpty || window <= 1) {
      return SmoothedSeries(
        raw: series,
        smoothed: series,
        estimatedLag: Duration.zero,
      );
    }

    final alpha = 2 / (window + 1);
    final points = <TimeSeriesPoint>[];
    double? ema;

    for (final point in series.points) {
      ema = ema == null ? point.value : alpha * point.value + (1 - alpha) * ema;
      points.add(TimeSeriesPoint(timestamp: point.timestamp, value: ema));
    }

    return SmoothedSeries(
      raw: series,
      smoothed: MarketSeries(points),
      estimatedLag: Duration(minutes: (window ~/ 2)),
    );
  }
}
