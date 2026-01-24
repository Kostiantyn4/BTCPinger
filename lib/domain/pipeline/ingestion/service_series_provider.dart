import '../../../services/btc_price_service.dart';
import '../models/time_series.dart';
import 'market_series_provider.dart';

class ServiceSeriesProvider implements MarketSeriesProvider {
  ServiceSeriesProvider(this._service);

  final BtcPriceService _service;

  @override
  Future<MarketSeries> loadSeries({required int days, bool forceRefresh = false}) async {
    final entries = await _service.fetchMarketChart(days: days);
    final points = entries
        .map((entry) => TimeSeriesPoint(timestamp: entry.timestamp, value: entry.price))
        .toList();
    return MarketSeries(points);
  }
}
