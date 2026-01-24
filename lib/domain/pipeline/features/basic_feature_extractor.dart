import 'dart:math' as math;

import '../models/smoothed_series.dart';
import '../models/time_series.dart';
import 'feature_extractor.dart';
import 'models/feature_frame.dart';

class BasicFeatureExtractor implements FeatureExtractor {
  BasicFeatureExtractor({this.volatilityWindow = 10});

  final int volatilityWindow;

  @override
  FeatureFrame extract(SmoothedSeries series) {
    final derivative = _computeDerivative(series.smoothed);
    final volatility = _rollingStd(series.smoothed, volatilityWindow);
    final atr = _atr(series.raw, volatilityWindow);

    return FeatureFrame(
      series: series.smoothed,
      derivative: derivative,
      volatility: volatility,
      atr: atr,
    );
  }

  List<double> _computeDerivative(MarketSeries series) {
    if (series.length < 2) return List.filled(series.length, 0);
    final result = <double>[0];
    for (var i = 1; i < series.length; i++) {
      final prev = series.points[i - 1];
      final curr = series.points[i];
      final dt = curr.timestamp.difference(prev.timestamp).inSeconds;
      if (dt == 0) {
        result.add(0);
        continue;
      }
      result.add((curr.value - prev.value) / dt);
    }
    return result;
  }

  List<double> _rollingStd(MarketSeries series, int window) {
    if (series.isEmpty) return [];
    final values = series.points.map((e) => e.value).toList();
    final output = List<double>.filled(values.length, 0);
    for (var i = 0; i < values.length; i++) {
      final start = i < window ? 0 : i - window + 1;
      final slice = values.sublist(start, i + 1);
      final mean = slice.reduce((a, b) => a + b) / slice.length;
      final variance =
          slice.fold<double>(0, (sum, v) => sum + (v - mean) * (v - mean)) / slice.length;
      output[i] = variance <= 0 ? 0 : math.sqrt(variance);
    }
    return output;
  }

  List<double> _atr(MarketSeries series, int window) {
    if (series.length < 2) return List<double>.filled(series.length, 0);
    final output = List<double>.filled(series.length, 0);
    for (var i = 1; i < series.length; i++) {
      final curr = series.points[i].value;
      final prev = series.points[i - 1].value;
      final tr = (curr - prev).abs();
      final start = i < window ? 1 : i - window + 1;
      final slice = series.points.sublist(start, i + 1);
      final avg = slice
              .asMap()
              .entries
              .skip(1)
              .map((entry) => (entry.value.value - slice[entry.key - 1].value).abs())
              .fold<double>(0, (sum, v) => sum + v) /
          (slice.length - 1);
      output[i] = avg.isNaN ? tr : avg;
    }
    return output;
  }
}
