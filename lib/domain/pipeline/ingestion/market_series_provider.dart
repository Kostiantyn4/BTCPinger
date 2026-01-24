import '../models/time_series.dart';

abstract class MarketSeriesProvider {
  Future<MarketSeries> loadSeries({
    required int days,
    bool forceRefresh = false,
  });
}
