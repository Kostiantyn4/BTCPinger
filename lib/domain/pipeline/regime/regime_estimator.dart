import '../features/models/feature_frame.dart';
import 'regime_state.dart';

abstract class RegimeEstimator {
  RegimeState estimate(FeatureFrame features);
}
