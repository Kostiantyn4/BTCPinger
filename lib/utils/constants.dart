// Application-wide constants
class AppConstants {
  // API endpoints
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';
  static const String marketChartEndpoint = '/coins/bitcoin/market_chart';
  static const String simplePriceEndpoint = '/simple/price';
  
  // Default values
  static const Duration defaultUpdateInterval = Duration(seconds: 10);
  static const Duration defaultTrendAnalysisInterval = Duration(hours: 24);
  static const int defaultDaysToAnalyze = 7;
  
  // Notification channels
  static const String priceAlertChannelId = 'price_alerts';
  static const String trendAlertChannelId = 'trend_alerts';
  
  // Database
  static const String databaseName = 'btc_pinger.db';
  static const String priceTableName = 'price_history';
  static const String settingsTableName = 'user_settings';
}
