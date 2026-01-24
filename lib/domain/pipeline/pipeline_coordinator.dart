import 'anomaly/anomaly_filter.dart';
import 'change_point/change_point_detector.dart';
import 'features/feature_extractor.dart';
import 'ingestion/market_series_provider.dart';
import 'pipeline_context.dart';
import 'regime/regime_estimator.dart';
import 'smoothing/signal_smoother.dart';

class PipelineCoordinator {
  PipelineCoordinator({
    required this.seriesProvider,
    required this.anomalyFilter,
    required this.signalSmoother,
    required this.featureExtractor,
    required this.regimeEstimator,
    required this.changePointDetector,
  });

  final MarketSeriesProvider seriesProvider;
  final AnomalyFilter anomalyFilter;
  final SignalSmoother signalSmoother;
  final FeatureExtractor featureExtractor;
  final RegimeEstimator regimeEstimator;
  final ChangePointDetector changePointDetector;

  Future<PipelineContext> run({required int days}) async {
    final raw = await seriesProvider.loadSeries(days: days);
    final filtered = anomalyFilter.filter(raw);
    final smoothed = signalSmoother.smooth(filtered);
    final features = featureExtractor.extract(smoothed);
    final regime = regimeEstimator.estimate(features);
    final change = changePointDetector.detect(features);

    return PipelineContext(
      raw: raw,
      anomalyFiltered: filtered,
      smoothed: smoothed,
      features: features,
      regimeState: regime,
      changePointState: change,
    );
  }
}
