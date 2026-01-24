import 'change_point/change_point_state.dart';
import 'features/models/feature_frame.dart';
import 'models/smoothed_series.dart';
import 'models/time_series.dart';
import 'regime/regime_state.dart';

class PipelineContext {
  PipelineContext({
    required this.raw,
    required this.anomalyFiltered,
    required this.smoothed,
    required this.features,
    required this.regimeState,
    required this.changePointState,
  });

  final MarketSeries raw;
  final MarketSeries anomalyFiltered;
  final SmoothedSeries smoothed;
  final FeatureFrame features;
  final RegimeState regimeState;
  final ChangePointState changePointState;
}
