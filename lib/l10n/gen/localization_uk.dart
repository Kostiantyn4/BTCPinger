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
  String get notificationDecisionBuyTitle => 'BTC рішення: Купувати';

  @override
  String get notificationDecisionSellTitle => 'BTC рішення: Продавати';

  @override
  String get notificationDecisionHoldTitle => 'BTC рішення: Утримувати';

  @override
  String notificationDecisionBody(Object price, Object ev, Object confidence) {
    return 'Ціна $price · EV $ev · Впевненість $confidence%';
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
  String get chartLoading => 'Завантаження графіку...';

  @override
  String get decisionEvLabel => 'Очікувана дохідність';

  @override
  String get decisionEvHint =>
      'Очікувана дохідність (EV) з урахуванням ймовірностей режимів та матриці виплат';

  @override
  String get decisionAdjustedLabel => 'EV з урахуванням лаґу';

  @override
  String get decisionAdjustedHint =>
      'Очікувана дохідність із застосуванням штрафу за оціночний лаґ';

  @override
  String get decisionConfidenceLabel => 'Впевненість';

  @override
  String get decisionConfidenceHint =>
      'Рівень впевненості моделі на основі модульованого сигналу';

  @override
  String get decisionSignalSectionTitle => 'Сила сигналу';

  @override
  String get decisionBaseSignalLabel => 'Базовий сигнал';

  @override
  String get decisionBaseSignalHint =>
      'Сирий сигнал з похідної/волатильності до модуляції';

  @override
  String get decisionModulatedSignalLabel => 'Ефективний сигнал';

  @override
  String get decisionModulatedSignalHint =>
      'Сигнал після врахування режимів і зміни тренду';

  @override
  String get decisionRegimeSectionTitle => 'Ймовірності режимів';

  @override
  String get decisionBullProbLabel => 'Бичачий';

  @override
  String get decisionBullProbHint =>
      'Ймовірність того, що ринок у бичачому режимі';

  @override
  String get decisionFlatProbLabel => 'Флет';

  @override
  String get decisionFlatProbHint =>
      'Ймовірність того, що ринок рухається боком';

  @override
  String get decisionBearProbLabel => 'Ведмежий';

  @override
  String get decisionBearProbHint =>
      'Ймовірність того, що ринок у ведмежому режимі';

  @override
  String get decisionChangeProbLabel => 'Ймовірність зміни';

  @override
  String get decisionChangeProbHint =>
      'Ймовірність виявленої структурної зміни (BOCPD)';

  @override
  String get decisionLagLabel => 'Ефективний лаґ';

  @override
  String get decisionLagHint =>
      'Сумарний оціночний лаґ від згладжування та режимів';

  @override
  String decisionMinutes(Object value) {
    return '$value хв';
  }

  @override
  String get decisionPenaltyLabel => 'Штраф за лаґ';

  @override
  String get decisionPenaltyHint =>
      'Множник, що зменшує EV через лаґ та ризик зміни';

  @override
  String get decisionRawConfidenceLabel => 'Сирий рівень впевненості';

  @override
  String get decisionRawConfidenceHint =>
      'Абсолютна сила модульованого сигналу до калібрування';

  @override
  String get decisionCalibratedConfidenceLabel => 'Калібрована впевненість';

  @override
  String get decisionCalibratedConfidenceHint =>
      'Впевненість після temperature scaling';

  @override
  String get decisionPrevActionLabel => 'Попередня дія';

  @override
  String get decisionPrevActionHint =>
      'Дія, яка трималась до підтвердження переключення';
}
