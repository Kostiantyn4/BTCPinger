import 'dart:math' as math;

import '../features/models/feature_frame.dart';
import 'change_point_detector.dart';
import 'change_point_state.dart';

class SimpleBocpdDetector implements ChangePointDetector {
  SimpleBocpdDetector({
    this.hazard = 1 / 200,
    this.threshold = 0.7,
  });

  final double hazard;
  final double threshold;

  double _runLengthProb = 0;
  DateTime? _lastChange;

  @override
  ChangePointState detect(FeatureFrame features) {
    if (features.length < 2) {
      return ChangePointState.neutral();
    }

    final latestIdx = features.length - 1;
    final derivative = features.derivative[latestIdx];
    final volatility = features.volatility[latestIdx];
    final normalized = volatility == 0 ? 0 : (derivative.abs() / (volatility + 1e-6));

    final growth = (1 - hazard) * _runLengthProb + hazard;
    final observationLikelihood = _likelihood(normalized.toDouble());
    _runLengthProb = growth * observationLikelihood;

    double probability = 1 - math.exp(-_runLengthProb);
    if (probability.isNaN || probability.isInfinite) {
      probability = 0;
    }

    if (probability > threshold) {
      _lastChange = features.series.points[latestIdx].timestamp;
      _runLengthProb = 0;
    }

    return ChangePointState(
      probability: probability,
      lastDetected: _lastChange,
    );
  }

  double _likelihood(double normalizedDerivative) {
    final scale = 1.5;
    return 1 - math.exp(-normalizedDerivative / scale);
  }
}
