import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/widgets.dart';

import '../config/app_config.dart';
import '../domain/pipeline/decision/decision_engine_factory.dart';
import '../domain/pipeline/decision/payoff_matrix.dart';
import '../services/btc_price_service.dart';
import '../services/notification_service.dart';

class AlarmManagerService {
  static const int priceMonitorId = 1001;

  static Future<void> schedulePriceMonitoring() async {
    final cfg = AppConfig.backgroundMonitoring;
    await AndroidAlarmManager.periodic(
      cfg.refreshInterval,
      priceMonitorId,
      priceMonitorCallback,
      startAt: DateTime.now().add(cfg.initialDelay),
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
    final cfg = AppConfig.backgroundMonitoring;
    final engine = DecisionEngineFactory.fromService(priceService);
    final decision = await engine.evaluate(days: cfg.pipelineWindowDays);
    final action = decision.decision.finalAction;

    if (action != TradingDecision.hold) {
      await notificationService.showDecisionNotification(
        decision: action,
        confidence: decision.decision.confidence,
        priceUsd: quote.usd,
        expectedValue: decision.decision.expectedValue,
      );
    }
  } catch (_) {
    // Swallow errors to keep background task running.
  } finally {
    priceService.dispose();
  }
}
