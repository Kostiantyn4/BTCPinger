// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LocalizationEn extends Localization {
  LocalizationEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BTC Pinger';

  @override
  String get navHome => 'Home';

  @override
  String get navHistory => 'History';

  @override
  String get navSettings => 'Settings';

  @override
  String get headerTitle => 'Trend analytics';

  @override
  String get trendCardTitle => '7-day price dynamics';

  @override
  String get trendCardSubtitle => 'Last 7 days';

  @override
  String get changeCardTitle => 'Change over last 3 days';

  @override
  String changeCardSevenDay(Object value) {
    return '7-day: $value';
  }

  @override
  String get alertTrendDetected =>
      'Price grew for 3 days in a row and then dropped — monitor the signal closely.';

  @override
  String get alertNoTrend => 'No critical trends detected.';

  @override
  String get decisionCardTitle => 'Decision Engine';

  @override
  String get decisionBuy => 'Buy';

  @override
  String get decisionSell => 'Sell';

  @override
  String get decisionHold => 'Hold';

  @override
  String get modelLabelMa => 'MA + σ';

  @override
  String get modelLabelRsi => 'RSI';

  @override
  String get modelLabelMarkov => 'Markov';

  @override
  String get priceHistoryTitle => 'Price History';

  @override
  String get priceHistoryPlaceholder => 'Price history will be displayed here';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPriceAlertsTitle => 'Price Alerts';

  @override
  String get settingsPriceAlertsDescription =>
      'Configure your price thresholds and notification settings here';

  @override
  String get settingsTrendTitle => 'Trend Analysis';

  @override
  String get settingsTrendDescription => 'Set up trend monitoring parameters';

  @override
  String get notificationBuyTitle => 'BTC Buy Signal';

  @override
  String get notificationSellTitle => 'BTC Sell Signal';

  @override
  String notificationBody(Object price, Object confidence) {
    return 'Current price: $price · Confidence $confidence%';
  }

  @override
  String get dayLabel1 => '1 day';

  @override
  String get dayLabel2 => '2 days';

  @override
  String get dayLabel3 => '3 days';

  @override
  String get dayLabel4 => '4 days';

  @override
  String get dayLabel5 => '5 days';

  @override
  String get dayLabel6 => '6 days';

  @override
  String get dayLabel7 => '7 days';

  @override
  String get chartLoading => 'Loading chart...';
}
