import '../change_point/change_point_state.dart';
import '../regime/regime_state.dart';

abstract class SignalModulator {
  double modulate(
    double baseSignal,
    RegimeState regime,
    ChangePointState changePoint,
  );
}
