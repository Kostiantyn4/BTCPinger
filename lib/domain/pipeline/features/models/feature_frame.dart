import '../../models/time_series.dart';

class FeatureFrame {
  FeatureFrame({
    required this.series,
    required this.derivative,
    required this.volatility,
    required this.atr,
  });

  final MarketSeries series;
  final List<double> derivative; // dX/dt for smoothed data
  final List<double> volatility; // rolling std dev
  final List<double> atr; // average true range proxy

  int get length => series.length;
}
