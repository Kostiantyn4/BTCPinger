import '../database/price_local_data_source.dart';
import '../models/price_entry.dart';
import '../models/price_quote.dart';
import '../services/btc_price_service.dart';

class PriceRepository {
  PriceRepository({
    required BtcPriceService service,
    required PriceLocalDataSource localDataSource,
  })  : _service = service,
        _localDataSource = localDataSource;

  final BtcPriceService _service;
  final PriceLocalDataSource _localDataSource;

  Future<PriceQuote> fetchQuote() => _service.fetchCurrentQuote();

  Future<List<PriceEntry>> loadHistory({
    bool forceRefresh = false,
    int days = 7,
  }) async {
    if (!forceRefresh) {
      final local = await _localDataSource.getEntries(currency: 'USD', limit: days);
      if (local.length >= days) {
        return local;
      }
    }

    final remote = await _service.fetchMarketChart(days: days);
    await _localDataSource.replaceEntries(currency: 'USD', entries: remote);
    return remote;
  }

  Future<void> upsertEntry(PriceEntry entry) => _localDataSource.upsertEntry(entry);

  void dispose() {
    _service.dispose();
  }
}
