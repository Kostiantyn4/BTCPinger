// Service for managing push notifications
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../l10n/gen/localization.dart';
import '../utils/analytics.dart';
import '../utils/helpers.dart';

class NotificationService {
  factory NotificationService() => _instance;

  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  Locale _locale = const Locale('uk');
  late Localization _localization = lookupLocalization(_locale);

  static const AndroidNotificationChannel _signalChannel = AndroidNotificationChannel(
    'btc_signal_channel',
    'BTC Trading Signals',
    description: 'Сповіщення про рекомендації купити або продати BTC',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const linuxSettings = LinuxInitializationSettings(defaultActionName: 'btc_signal_action');
    const initSettings = InitializationSettings(
      android: androidSettings,
      linux: linuxSettings,
    );

    await _plugin.initialize(initSettings);
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_signalChannel);
      await androidPlugin.requestNotificationsPermission();
    }
    _initialized = true;
  }

  void updateLocale(Locale locale) {
    _locale = locale;
    _localization = lookupLocalization(_locale);
  }

  Future<void> showTradingNotification({
    required TradingSignal signal,
    required double confidence,
    required double priceUsd,
  }) async {
    if (!_initialized) await initialize();
    updateLocale(_locale);

    final isBuy = signal == TradingSignal.buy;
    final title =
        isBuy ? _localization.notificationBuyTitle : _localization.notificationSellTitle;
    final body = _localization.notificationBody(
      AppHelpers.formatPrice(priceUsd),
      (confidence * 100).toStringAsFixed(1),
    );

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _signalChannel.id,
        _signalChannel.name,
        channelDescription: _signalChannel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(signal.index + 1, title, body, details);
  }

  // TODO: Implement trend notification
  Future<void> showTrendAlert({
    required String trend,
    required int days,
    required double priceChange,
  }) async {
    throw UnimplementedError();
  }
}
