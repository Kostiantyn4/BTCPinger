import '../../../repository/price_repository.dart';
import '../models/time_series.dart';
import 'market_series_provider.dart';

class PriceRepositorySeriesProvider implements MarketSeriesProvider {
  PriceRepositorySeriesProvider(this._repository);

  final PriceRepository _repository;

  @override
  Future<MarketSeries> loadSeries({required int days, bool forceRefresh = false}) async {
    final entries = await _repository.loadHistory(days: days, forceRefresh: forceRefresh);
    final points = entries
        .map((entry) => TimeSeriesPoint(timestamp: entry.timestamp, value: entry.price))
        .toList();
    return MarketSeries(points);
  }
}
