import '../../../repository/price_repository.dart';
import '../../../services/btc_price_service.dart';
import '../anomaly/sigma_censoring_filter.dart';
import '../change_point/simple_bocpd_detector.dart';
import '../features/basic_feature_extractor.dart';
import '../ingestion/market_series_provider.dart';
import '../ingestion/price_repository_series_provider.dart';
import '../ingestion/service_series_provider.dart';
import '../modulation/simple_signal_modulator.dart';
import '../pipeline_coordinator.dart';
import '../regime/simple_hmm_regime_estimator.dart';
import '../smoothing/ema_smoother.dart';
import 'advanced_decision_engine.dart';
import 'expected_value_optimizer.dart';
import 'payoff_matrix.dart';

class DecisionEngineFactory {
  static AdvancedDecisionEngine fromRepository(PriceRepository repository) {
    return _build(PriceRepositorySeriesProvider(repository));
  }

  static AdvancedDecisionEngine fromService(BtcPriceService service) {
    return _build(ServiceSeriesProvider(service));
  }

  static AdvancedDecisionEngine _build(MarketSeriesProvider provider) {
    final anomalyFilter = SigmaCensoringFilter(sigmaMultiplier: 3);
    final smoother = EmaSmoother(window: 12);
    final featureExtractor = BasicFeatureExtractor(volatilityWindow: 10);
    final regimeEstimator = SimpleHmmRegimeEstimator(
      window: 24,
      transitionMatrix: const [
        [0.88, 0.09, 0.03],
        [0.2, 0.6, 0.2],
        [0.05, 0.15, 0.8],
      ],
      emissionStd: 0.02,
    );
    final changePointDetector = SimpleBocpdDetector(
      hazard: 1 / 150,
      threshold: 0.65,
    );
    final coordinator = PipelineCoordinator(
      seriesProvider: provider,
      anomalyFilter: anomalyFilter,
      signalSmoother: smoother,
      featureExtractor: featureExtractor,
      regimeEstimator: regimeEstimator,
      changePointDetector: changePointDetector,
    );
    final modulator = SimpleSignalModulator(
      changePointPenalty: 0.6,
      minRegimeWeight: 0.25,
    );
    final optimizer = ExpectedValueOptimizer(
      payoffMatrix: PayoffMatrix.defaultMatrix(),
      lagPenalty: 0.05,
    );

    return AdvancedDecisionEngine(
      coordinator: coordinator,
      modulator: modulator,
      optimizer: optimizer,
      signalThreshold: 0.08,
    );
  }
}
