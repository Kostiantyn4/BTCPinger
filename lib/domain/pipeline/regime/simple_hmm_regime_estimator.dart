import 'dart:math' as math;

import '../features/models/feature_frame.dart';
import 'regime_estimator.dart';
import 'regime_state.dart';

class SimpleHmmRegimeEstimator implements RegimeEstimator {
  SimpleHmmRegimeEstimator({
    required this.window,
    required this.transitionMatrix,
    required this.emissionStd,
  });

  final int window;
  final List<List<double>> transitionMatrix; // 3x3 matrix
  final double emissionStd;
  List<double> _stateProbabilities = const [1 / 3, 1 / 3, 1 / 3];

  @override
  RegimeState estimate(FeatureFrame features) {
    if (features.length < window) {
      return RegimeState.neutral();
    }

    final recent = features.series.points.sublist(features.length - window);
    final returns = <double>[];
    for (var i = 1; i < recent.length; i++) {
      final prev = recent[i - 1].value;
      if (prev == 0) continue;
      returns.add((recent[i].value - prev) / prev);
    }

    final emissions = _computeEmissions(returns);
    final newProb = List<double>.filled(3, 0);
    for (var i = 0; i < 3; i++) {
      double sum = 0;
      for (var j = 0; j < 3; j++) {
        sum += _stateProbabilities[j] * transitionMatrix[j][i];
      }
      newProb[i] = sum * emissions[i];
    }

    final total = newProb.reduce((a, b) => a + b);
    _stateProbabilities = total == 0
        ? const [1 / 3, 1 / 3, 1 / 3]
        : newProb.map((p) => p / total).toList();

    return RegimeState(
      probBull: _stateProbabilities[0],
      probFlat: _stateProbabilities[1],
      probBear: _stateProbabilities[2],
      estimatedLag: Duration(minutes: window ~/ 2),
    );
  }

  List<double> _computeEmissions(List<double> returns) {
    if (returns.isEmpty) {
      return const [1 / 3, 1 / 3, 1 / 3];
    }
    final mean = returns.reduce((a, b) => a + b) / returns.length;
    final variance = returns.fold<double>(0, (sum, r) => sum + math.pow(r - mean, 2)) /
        math.max(returns.length - 1, 1);
    final std = math.sqrt(variance);

    final bullScore = _gaussianPdf(mean, std, emissionStd);
    final bearScore = _gaussianPdf(-mean, std, emissionStd);
    final flatScore = std < emissionStd ? 1.0 : emissionStd / std;

    final total = bullScore + bearScore + flatScore;
    if (total == 0) return const [1 / 3, 1 / 3, 1 / 3];

    return [bullScore / total, flatScore / total, bearScore / total];
  }

  double _gaussianPdf(double x, double std, double targetStd) {
    final variance = math.pow(targetStd, 2).toDouble();
    if (variance == 0) return 0;
    return (1 / math.sqrt(2 * math.pi * variance)) *
        math.exp(-math.pow(x, 2) / (2 * variance));
  }
}
