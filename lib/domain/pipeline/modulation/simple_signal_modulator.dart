import '../change_point/change_point_state.dart';
import '../regime/regime_state.dart';
import 'signal_modulator.dart';

class SimpleSignalModulator implements SignalModulator {
  SimpleSignalModulator({
    this.changePointPenalty = 0.6,
    this.minRegimeWeight = 0.2,
  });

  final double changePointPenalty;
  final double minRegimeWeight;

  @override
  double modulate(
    double baseSignal,
    RegimeState regime,
    ChangePointState changePoint,
  ) {
    if (baseSignal == 0) return 0;

    final regimeWeight = baseSignal > 0
        ? (regime.probBull - regime.probBear).clamp(minRegimeWeight, 1.0)
        : (regime.probBear - regime.probBull).clamp(minRegimeWeight, 1.0);

    final changePenalty = 1 - (changePoint.probability * changePointPenalty).clamp(0, 0.9);

    return baseSignal * regimeWeight * changePenalty;
  }
}
