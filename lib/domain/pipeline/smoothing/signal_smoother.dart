import '../models/smoothed_series.dart';
import '../models/time_series.dart';

abstract class SignalSmoother {
  SmoothedSeries smooth(MarketSeries series);
}
