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
  String get notificationDecisionBuyTitle => 'BTC decision: Buy';

  @override
  String get notificationDecisionSellTitle => 'BTC decision: Sell';

  @override
  String get notificationDecisionHoldTitle => 'BTC decision: Hold';

  @override
  String notificationDecisionBody(Object price, Object ev, Object confidence) {
    return 'Price $price · EV $ev · Confidence $confidence%';
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

  @override
  String get decisionEvLabel => 'Expected value';

  @override
  String get decisionEvHint =>
      'Expected value (EV) based on regime probabilities and payoff matrix';

  @override
  String get decisionAdjustedLabel => 'Lag-adjusted EV';

  @override
  String get decisionAdjustedHint =>
      'Expected value adjusted by the estimated execution lag penalty';

  @override
  String get decisionConfidenceLabel => 'Confidence';

  @override
  String get decisionConfidenceHint =>
      'Model confidence derived from the modulated signal strength';

  @override
  String get decisionSignalSectionTitle => 'Signal strength';

  @override
  String get decisionBaseSignalLabel => 'Base signal';

  @override
  String get decisionBaseSignalHint =>
      'Raw signal from derivative/volatility ratio before modulation';

  @override
  String get decisionModulatedSignalLabel => 'Effective signal';

  @override
  String get decisionModulatedSignalHint =>
      'Signal after regime and change-point modulation';

  @override
  String get decisionRegimeSectionTitle => 'Regime probabilities';

  @override
  String get decisionBullProbLabel => 'Bull';

  @override
  String get decisionBullProbHint =>
      'Probability that market is currently in a bullish regime';

  @override
  String get decisionFlatProbLabel => 'Flat';

  @override
  String get decisionFlatProbHint =>
      'Probability that market is currently moving sideways';

  @override
  String get decisionBearProbLabel => 'Bear';

  @override
  String get decisionBearProbHint =>
      'Probability that market is currently in a bearish regime';

  @override
  String get decisionChangeProbLabel => 'Change probability';

  @override
  String get decisionChangeProbHint =>
      'Probability of a detected structural change (BOCPD)';

  @override
  String get decisionLagLabel => 'Effective lag';

  @override
  String get decisionLagHint =>
      'Combined estimated lag from smoothing and regime filters';

  @override
  String decisionMinutes(Object value) {
    return '$value min';
  }

  @override
  String get decisionPenaltyLabel => 'Lag penalty';

  @override
  String get decisionPenaltyHint =>
      'Multiplier applied to EV due to lag and change risk';

  @override
  String get decisionRawConfidenceLabel => 'Raw confidence';

  @override
  String get decisionRawConfidenceHint =>
      'Absolute modulated signal strength before calibration';

  @override
  String get decisionCalibratedConfidenceLabel => 'Calibrated confidence';

  @override
  String get decisionCalibratedConfidenceHint =>
      'Confidence adjusted via temperature scaling';

  @override
  String get decisionPrevActionLabel => 'Previous action';

  @override
  String get decisionPrevActionHint =>
      'The action held before hysteresis confirmed a switch';
}
