import '../regime/regime_state.dart';
import 'payoff_matrix.dart';

class ExpectedValueResult {
  const ExpectedValueResult({
    required this.decision,
    required this.expectedValue,
    required this.adjustedScore,
    required this.penaltyFactor,
  });

  final TradingDecision decision;
  final double expectedValue;
  final double adjustedScore;
  final double penaltyFactor;
}

class ExpectedValueOptimizer {
  ExpectedValueOptimizer({
    required this.payoffMatrix,
    this.lagPenalty = 0.1,
  });

  final PayoffMatrix payoffMatrix;
  final double lagPenalty;

  ExpectedValueResult optimize({
    required RegimeState regimeState,
    required Duration decisionLag,
    double changeProbability = 0,
  }) {
    final probs = {
      MarketRegime.bull: regimeState.probBull,
      MarketRegime.flat: regimeState.probFlat,
      MarketRegime.bear: regimeState.probBear,
    };

    final penaltyFactor = 1 + lagPenalty * decisionLag.inMinutes * (1 + changeProbability);
    ExpectedValueResult? best;
    for (final decision in TradingDecision.values) {
      final ev = probs.entries.fold<double>(
        0,
        (sum, entry) => sum + entry.value * payoffMatrix.payoff(decision, entry.key),
      );
      final adjusted = ev / penaltyFactor;
      if (best == null || adjusted > best.adjustedScore) {
        best = ExpectedValueResult(
          decision: decision,
          expectedValue: ev,
          adjustedScore: adjusted,
          penaltyFactor: penaltyFactor,
        );
      }
    }
    return best ??
        const ExpectedValueResult(
          decision: TradingDecision.hold,
          expectedValue: 0,
          adjustedScore: 0,
          penaltyFactor: 1,
        );
  }
}
