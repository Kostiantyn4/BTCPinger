import '../models/time_series.dart';
import 'anomaly_filter.dart';

class SigmaCensoringFilter implements AnomalyFilter {
  SigmaCensoringFilter({this.sigmaMultiplier = 3});

  final double sigmaMultiplier;

  @override
  MarketSeries filter(MarketSeries series) {
    if (series.isEmpty) return series;
    final mean = series.mean;
    final std = series.standardDeviation;
    if (std == 0) return series;

    final upper = mean + sigmaMultiplier * std;
    final lower = mean - sigmaMultiplier * std;

    final points = series.points
        .map(
          (point) => point.value.clamp(lower, upper) == point.value
              ? point
              : TimeSeriesPoint(
                  timestamp: point.timestamp,
                  value: point.value > upper ? upper : lower,
                ),
        )
        .toList();

    return MarketSeries(points);
  }
}
