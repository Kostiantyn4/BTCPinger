import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/price_entry.dart';
import '../models/price_quote.dart';
import '../utils/constants.dart';

/// Service responsible for fetching Bitcoin pricing data from CoinGecko.
class BtcPriceService {
  BtcPriceService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<PriceQuote> fetchCurrentQuote() async {
    final uri = Uri.parse(
      '${AppConstants.coinGeckoBaseUrl}${AppConstants.simplePriceEndpoint}',
    ).replace(
      queryParameters: {
        'ids': 'bitcoin',
        'vs_currencies': 'usd,uah',
      },
    );

    final response = await _client.get(uri);
    _ensureSuccess(response);

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final data = payload['bitcoin'] as Map<String, dynamic>;
    final usd = (data['usd'] as num).toDouble();
    final uah = (data['uah'] as num).toDouble();

    return PriceQuote(
      timestamp: DateTime.now(),
      usd: usd,
      uah: uah,
    );
  }

  Future<List<PriceEntry>> fetchMarketChart({
    int days = AppConstants.defaultDaysToAnalyze,
  }) async {
    final uri = Uri.parse(
      '${AppConstants.coinGeckoBaseUrl}${AppConstants.marketChartEndpoint}',
    ).replace(
      queryParameters: {
        'vs_currency': 'usd',
        'days': days.toString(),
        'interval': 'daily',
      },
    );

    final response = await _client.get(uri);
    _ensureSuccess(response);

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final prices = payload['prices'] as List<dynamic>;

    return prices.map((entry) {
      final point = entry as List<dynamic>;
      final timestamp = DateTime.fromMillisecondsSinceEpoch(
        (point[0] as num).toInt(),
        isUtc: true,
      ).toLocal();
      final price = (point[1] as num).toDouble();
      return PriceEntry(
        timestamp: timestamp,
        price: price,
        currency: 'USD',
      );
    }).toList();
  }

  void dispose() {
    _client.close();
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('CoinGecko error: ${response.statusCode}: ${response.body}');
    }
  }
}
