import '../features/models/feature_frame.dart';
import 'change_point_state.dart';

abstract class ChangePointDetector {
  ChangePointState detect(FeatureFrame features);
}
