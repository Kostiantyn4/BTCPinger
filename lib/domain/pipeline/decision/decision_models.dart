import 'payoff_matrix.dart';

class SignalState {
  const SignalState({
    required this.base,
    required this.modulated,
    required this.rawDerivative,
    required this.volatility,
  });

  final double base;
  final double modulated;
  final double rawDerivative;
  final double volatility;
}

class DecisionState {
  const DecisionState({
    required this.action,
    required this.optimizedAction,
    required this.finalAction,
    required this.expectedValue,
    required this.adjustedScore,
    required this.confidence,
    required this.calibratedConfidence,
    required this.effectiveLag,
    required this.trace,
  });

  final TradingDecision action;
  final TradingDecision optimizedAction;
  final TradingDecision finalAction;
  final double expectedValue;
  final double adjustedScore;
  final double confidence;
  final double calibratedConfidence;
  final Duration effectiveLag;
  final DecisionTrace trace;
}

class DecisionTrace {
  const DecisionTrace({
    required this.changeProbability,
    required this.lagPenaltyMultiplier,
    required this.rawConfidence,
    required this.calibratedConfidence,
    required this.previousAction,
  });

  final double changeProbability;
  final double lagPenaltyMultiplier;
  final double rawConfidence;
  final double calibratedConfidence;
  final TradingDecision? previousAction;
}
