import '../models/time_series.dart';

abstract class AnomalyFilter {
  MarketSeries filter(MarketSeries series);
}
