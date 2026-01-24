import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/widgets.dart';

import '../services/btc_price_service.dart';
import '../services/notification_service.dart';
import '../utils/analytics.dart';

class AlarmManagerService {
  static const int priceMonitorId = 1001;

  static Future<void> schedulePriceMonitoring() async {
    await AndroidAlarmManager.periodic(
      const Duration(minutes: 15),
      priceMonitorId,
      priceMonitorCallback,
      startAt: DateTime.now().add(const Duration(minutes: 1)),
      allowWhileIdle: true,
      wakeup: true,
    );
  }
}

@pragma('vm:entry-point')
Future<void> priceMonitorCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final priceService = BtcPriceService();
  try {
    final quote = await priceService.fetchCurrentQuote();
    final history = await priceService.fetchMarketChart(days: 7);
    final decision = AnalyticsEngine.evaluate(history);

    if (decision.signal != TradingSignal.hold) {
      await notificationService.showTradingNotification(
        signal: decision.signal,
        confidence: decision.confidence,
        priceUsd: quote.usd,
      );
    }
  } catch (_) {
    // Swallow errors to keep background task running.
  } finally {
    priceService.dispose();
  }
}
