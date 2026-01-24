import '../models/smoothed_series.dart';
import 'models/feature_frame.dart';

abstract class FeatureExtractor {
  FeatureFrame extract(SmoothedSeries series);
}
