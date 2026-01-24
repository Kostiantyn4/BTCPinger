import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localization_en.dart';
import 'localization_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of Localization
/// returned by `Localization.of(context)`.
///
/// Applications need to include `Localization.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/localization.dart';
///
/// return MaterialApp(
///   localizationsDelegates: Localization.localizationsDelegates,
///   supportedLocales: Localization.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the Localization.supportedLocales
/// property.
abstract class Localization {
  Localization(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization)!;
  }

  static const LocalizationsDelegate<Localization> delegate =
      _LocalizationDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BTC Pinger'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @headerTitle.
  ///
  /// In en, this message translates to:
  /// **'Trend analytics'**
  String get headerTitle;

  /// No description provided for @trendCardTitle.
  ///
  /// In en, this message translates to:
  /// **'7-day price dynamics'**
  String get trendCardTitle;

  /// No description provided for @trendCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get trendCardSubtitle;

  /// No description provided for @changeCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Change over last 3 days'**
  String get changeCardTitle;

  /// Label that shows the seven day percentage change
  ///
  /// In en, this message translates to:
  /// **'7-day: {value}'**
  String changeCardSevenDay(Object value);

  /// No description provided for @alertTrendDetected.
  ///
  /// In en, this message translates to:
  /// **'Price grew for 3 days in a row and then dropped — monitor the signal closely.'**
  String get alertTrendDetected;

  /// No description provided for @alertNoTrend.
  ///
  /// In en, this message translates to:
  /// **'No critical trends detected.'**
  String get alertNoTrend;

  /// No description provided for @decisionCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision Engine'**
  String get decisionCardTitle;

  /// No description provided for @decisionBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get decisionBuy;

  /// No description provided for @decisionSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get decisionSell;

  /// No description provided for @decisionHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get decisionHold;

  /// No description provided for @modelLabelMa.
  ///
  /// In en, this message translates to:
  /// **'MA + σ'**
  String get modelLabelMa;

  /// No description provided for @modelLabelRsi.
  ///
  /// In en, this message translates to:
  /// **'RSI'**
  String get modelLabelRsi;

  /// No description provided for @modelLabelMarkov.
  ///
  /// In en, this message translates to:
  /// **'Markov'**
  String get modelLabelMarkov;

  /// No description provided for @priceHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Price History'**
  String get priceHistoryTitle;

  /// No description provided for @priceHistoryPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Price history will be displayed here'**
  String get priceHistoryPlaceholder;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsPriceAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Alerts'**
  String get settingsPriceAlertsTitle;

  /// No description provided for @settingsPriceAlertsDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure your price thresholds and notification settings here'**
  String get settingsPriceAlertsDescription;

  /// No description provided for @settingsTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Trend Analysis'**
  String get settingsTrendTitle;

  /// No description provided for @settingsTrendDescription.
  ///
  /// In en, this message translates to:
  /// **'Set up trend monitoring parameters'**
  String get settingsTrendDescription;

  /// No description provided for @notificationBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'BTC Buy Signal'**
  String get notificationBuyTitle;

  /// No description provided for @notificationSellTitle.
  ///
  /// In en, this message translates to:
  /// **'BTC Sell Signal'**
  String get notificationSellTitle;

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'Current price: {price} · Confidence {confidence}%'**
  String notificationBody(Object price, Object confidence);

  /// No description provided for @dayLabel1.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get dayLabel1;

  /// No description provided for @dayLabel2.
  ///
  /// In en, this message translates to:
  /// **'2 days'**
  String get dayLabel2;

  /// No description provided for @dayLabel3.
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get dayLabel3;

  /// No description provided for @dayLabel4.
  ///
  /// In en, this message translates to:
  /// **'4 days'**
  String get dayLabel4;

  /// No description provided for @dayLabel5.
  ///
  /// In en, this message translates to:
  /// **'5 days'**
  String get dayLabel5;

  /// No description provided for @dayLabel6.
  ///
  /// In en, this message translates to:
  /// **'6 days'**
  String get dayLabel6;

  /// No description provided for @dayLabel7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get dayLabel7;

  /// No description provided for @chartLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading chart...'**
  String get chartLoading;
}

class _LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const _LocalizationDelegate();

  @override
  Future<Localization> load(Locale locale) {
    return SynchronousFuture<Localization>(lookupLocalization(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}

Localization lookupLocalization(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LocalizationEn();
    case 'uk':
      return LocalizationUk();
  }

  throw FlutterError(
    'Localization.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
