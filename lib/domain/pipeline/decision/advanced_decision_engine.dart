import 'dart:math' as math;

import 'package:collection/collection.dart';

import '../modulation/signal_modulator.dart';
import '../pipeline_coordinator.dart';
import '../pipeline_context.dart';
import 'decision_models.dart';
import 'expected_value_optimizer.dart';
import 'payoff_matrix.dart';

class AdvancedDecisionResult {
  const AdvancedDecisionResult({
    required this.signal,
    required this.decision,
    required this.context,
  });

  final SignalState signal;
  final DecisionState decision;
  final PipelineContext context;
}

class AdvancedDecisionEngine {
  AdvancedDecisionEngine({
    required this.coordinator,
    required this.modulator,
    required this.optimizer,
    this.signalThreshold = 0.05,
    this.temperature = 0.5,
    this.switchThreshold = 0.1,
  });

  final PipelineCoordinator coordinator;
  final SignalModulator modulator;
  final ExpectedValueOptimizer optimizer;
  final double signalThreshold;
  final double temperature;
  final double switchThreshold;

  Future<AdvancedDecisionResult> evaluate({
    required int days,
    TradingDecision? previousAction,
  }) async {
    final context = await coordinator.run(days: days);
    final derivative = (context.features.derivative.lastOrNull ?? 0).toDouble();
    final volatility = (context.features.volatility.lastOrNull ?? 0).toDouble();
    final baseSignal = _computeBaseSignal(derivative, volatility);
    final modulated = modulator.modulate(
      baseSignal,
      context.regimeState,
      context.changePointState,
    );

    final thresholdDecision = _decisionFromSignal(modulated);
    final totalLag = context.smoothed.estimatedLag + context.regimeState.estimatedLag;
    final evResult = optimizer.optimize(
      regimeState: context.regimeState,
      decisionLag: totalLag,
      changeProbability: context.changePointState.probability,
    );

    final rawConfidence = modulated.abs().clamp(0, 1).toDouble();
    final calibratedConfidence = _calibrateConfidence(evResult.adjustedScore);
    final combinedConfidence =
        ((rawConfidence + calibratedConfidence) / 2).clamp(0, 1).toDouble();
    final finalAction = _applyHysteresis(
      optimizedAction: evResult.decision,
      previousAction: previousAction,
      confidence: combinedConfidence,
    );

    final signalState = SignalState(
      base: baseSignal,
      modulated: modulated,
      rawDerivative: derivative,
      volatility: volatility,
    );

    final decisionState = DecisionState(
      action: thresholdDecision,
      optimizedAction: evResult.decision,
      finalAction: finalAction,
      expectedValue: evResult.expectedValue,
      adjustedScore: evResult.adjustedScore,
      confidence: combinedConfidence,
      calibratedConfidence: calibratedConfidence,
      effectiveLag: totalLag,
      trace: DecisionTrace(
        changeProbability: context.changePointState.probability,
        lagPenaltyMultiplier: evResult.penaltyFactor,
        rawConfidence: rawConfidence,
        calibratedConfidence: calibratedConfidence,
        previousAction: previousAction,
      ),
    );

    return AdvancedDecisionResult(
      signal: signalState,
      decision: decisionState,
      context: context,
    );
  }

  double _computeBaseSignal(double derivative, double volatility) {
    if (volatility == 0) {
      return derivative.sign.toDouble();
    }
    return (derivative / (volatility + 1e-6)).clamp(-1.0, 1.0).toDouble();
  }

  double _calibrateConfidence(double adjustedScore) {
    final temp = temperature <= 0 ? 1e-3 : temperature;
    final scaled = 1 / (1 + math.exp(-adjustedScore / temp));
    return scaled.clamp(0, 1).toDouble();
  }

  TradingDecision _applyHysteresis({
    required TradingDecision optimizedAction,
    TradingDecision? previousAction,
    required double confidence,
  }) {
    if (previousAction == null || previousAction == optimizedAction) {
      return optimizedAction;
    }
    if (confidence >= switchThreshold) {
      return optimizedAction;
    }
    return previousAction;
  }

  TradingDecision _decisionFromSignal(double signal) {
    if (signal > signalThreshold) return TradingDecision.buy;
    if (signal < -signalThreshold) return TradingDecision.sell;
    return TradingDecision.hold;
  }
}
