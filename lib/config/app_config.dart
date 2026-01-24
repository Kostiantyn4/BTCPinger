/// Centralized application configuration constants.
/// Extend this file with user-facing settings later (e.g. editable via UI).
class AppConfig {
  AppConfig._();

  static const BackgroundMonitoringConfig backgroundMonitoring =
      BackgroundMonitoringConfig();
}

class BackgroundMonitoringConfig {
  const BackgroundMonitoringConfig({
    this.refreshInterval = const Duration(minutes: 5),
    this.initialDelay = const Duration(seconds: 30),
    this.pipelineWindowDays = 30,
  });

  final Duration refreshInterval;
  final Duration initialDelay;
  final int pipelineWindowDays;
}
