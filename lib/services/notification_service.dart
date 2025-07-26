// Service for managing push notifications
class NotificationService {
  // TODO: Implement notification initialization
  Future<void> initialize() async {
    throw UnimplementedError();
  }

  // TODO: Implement price alert notification
  Future<void> showPriceAlert({
    required double currentPrice,
    required double threshold,
    required bool isAboveThreshold,
  }) async {
    throw UnimplementedError();
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
