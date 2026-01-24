// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localization.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class LocalizationUk extends Localization {
  LocalizationUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'BTC Pinger';

  @override
  String get navHome => 'Головна';

  @override
  String get navHistory => 'Історія';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get headerTitle => 'Аналітика трендів';

  @override
  String get trendCardTitle => 'Динаміка курсу за 7 днів';

  @override
  String get trendCardSubtitle => 'Останні 7 днів';

  @override
  String get changeCardTitle => 'Зміна за останні 3 дні';

  @override
  String changeCardSevenDay(Object value) {
    return 'Семиденна: $value';
  }

  @override
  String get alertTrendDetected =>
      'Ціна зростала 3 дні поспіль, а потім зафіксовано падіння — уважно стежте за сигналом.';

  @override
  String get alertNoTrend => 'Помітних критичних трендів не зафіксовано.';

  @override
  String get decisionCardTitle => 'Рішення алгоритму';

  @override
  String get decisionBuy => 'Купувати';

  @override
  String get decisionSell => 'Продавати';

  @override
  String get decisionHold => 'Утримувати';

  @override
  String get modelLabelMa => 'MA + σ';

  @override
  String get modelLabelRsi => 'RSI';

  @override
  String get modelLabelMarkov => 'Markov';

  @override
  String get priceHistoryTitle => 'Історія цін';

  @override
  String get priceHistoryPlaceholder => 'Тут буде відображено історію цін';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsPriceAlertsTitle => 'Сповіщення про ціну';

  @override
  String get settingsPriceAlertsDescription =>
      'Налаштуйте пороги та параметри сповіщень';

  @override
  String get settingsTrendTitle => 'Аналіз трендів';

  @override
  String get settingsTrendDescription =>
      'Задайте параметри моніторингу трендів';

  @override
  String get notificationBuyTitle => 'Сигнал купівлі BTC';

  @override
  String get notificationSellTitle => 'Сигнал продажу BTC';

  @override
  String notificationBody(Object price, Object confidence) {
    return 'Поточна ціна: $price · Впевненість $confidence%';
  }

  @override
  String get dayLabel1 => '1 день';

  @override
  String get dayLabel2 => '2 дні';

  @override
  String get dayLabel3 => '3 дні';

  @override
  String get dayLabel4 => '4 дні';

  @override
  String get dayLabel5 => '5 днів';

  @override
  String get dayLabel6 => '6 днів';

  @override
  String get dayLabel7 => '7 днів';

  @override
  String get chartLoading => 'Завантаження графіка...';
}
