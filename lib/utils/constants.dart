// Application-wide constants
class AppConstants {
  // API endpoints
  static const String btcPriceApiUrl = 'TODO: Add API endpoint';
  
  // Default values
  static const Duration defaultUpdateInterval = Duration(minutes: 5);
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
