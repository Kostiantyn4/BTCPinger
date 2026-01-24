import 'dart:math';

import '../models/price_entry.dart';

enum TradingSignal { buy, hold, sell }

class ModelSignal {
  const ModelSignal({required this.signal, required this.confidence});

  final TradingSignal signal;
  final double confidence; // 0..1
}

class DecisionResult {
  const DecisionResult({
    required this.signal,
    required this.confidence,
    required this.components,
  });

  final TradingSignal signal;
  final double confidence;
  final Map<String, ModelSignal> components;
}

class AnalyticsEngine {
  static DecisionResult evaluate(
    List<PriceEntry> history, {
    int movingAverageWindow = 7,
    double markovThresholdPercent = 0.5,
    double rsiPeriod = 14,
    double wMa = 0.4,
    double wRsi = 0.3,
    double wMarkov = 0.3,
  }) {
    if (history.length < 3) {
      return const DecisionResult(
        signal: TradingSignal.hold,
        confidence: 0,
        components: {},
      );
    }

    final maSignal = _movingAverageSignal(history, movingAverageWindow);
    final rsiSignal = _rsiSignal(history, rsiPeriod.toInt());
    final markovSignal = _markovSignal(history, markovThresholdPercent / 100);

    final weighted = {
      'ma': ModelSignal(
        signal: maSignal.signal,
        confidence: maSignal.confidence * wMa,
      ),
      'rsi': ModelSignal(
        signal: rsiSignal.signal,
        confidence: rsiSignal.confidence * wRsi,
      ),
      'markov': ModelSignal(
        signal: markovSignal.signal,
        confidence: markovSignal.confidence * wMarkov,
      ),
    };

    final buyScore = weighted.values
        .where((s) => s.signal == TradingSignal.buy)
        .fold<double>(0, (sum, s) => sum + s.confidence);
    final sellScore = weighted.values
        .where((s) => s.signal == TradingSignal.sell)
        .fold<double>(0, (sum, s) => sum + s.confidence);
    final holdScore = weighted.values
        .where((s) => s.signal == TradingSignal.hold)
        .fold<double>(0, (sum, s) => sum + s.confidence);

    final scores = {
      TradingSignal.buy: buyScore,
      TradingSignal.sell: sellScore,
      TradingSignal.hold: holdScore,
    };

    TradingSignal finalSignal = TradingSignal.hold;
    double maxScore = -1;
    scores.forEach((signal, score) {
      if (score > maxScore) {
        maxScore = score;
        finalSignal = signal;
      }
    });

    final confidence = maxScore.clamp(0, 1).toDouble();

    return DecisionResult(
      signal: finalSignal,
      confidence: confidence,
      components: {
        'ma': maSignal,
        'rsi': rsiSignal,
        'markov': markovSignal,
      },
    );
  }

  static ModelSignal _movingAverageSignal(List<PriceEntry> history, int window) {
    if (history.length < window) {
      return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
    }
    final recent = history.sublist(history.length - window);
    final prices = recent.map((e) => e.price).toList();
    final ma = prices.reduce((a, b) => a + b) / window;
    final latest = prices.last;

    final variance = prices
            .map((price) => pow(price - ma, 2).toDouble())
            .reduce((a, b) => a + b) /
        window;
    final stdDev = sqrt(variance);

    if (stdDev == 0) {
      return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
    }

    if (latest < ma - stdDev) {
      final diff = (ma - stdDev - latest) / stdDev;
      return ModelSignal(
        signal: TradingSignal.buy,
        confidence: diff.clamp(0, 1).toDouble(),
      );
    }
    if (latest > ma + stdDev) {
      final diff = (latest - (ma + stdDev)) / stdDev;
      return ModelSignal(
        signal: TradingSignal.sell,
        confidence: diff.clamp(0, 1).toDouble(),
      );
    }
    return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
  }

  static ModelSignal _rsiSignal(List<PriceEntry> history, int period) {
    if (history.length <= period) {
      return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
    }

    double gains = 0;
    double losses = 0;
    for (int i = history.length - period + 1; i < history.length; i++) {
      final change = history[i].price - history[i - 1].price;
      if (change > 0) {
        gains += change;
      } else {
        losses += change.abs();
      }
    }

    if (gains == 0 && losses == 0) {
      return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
    }

    final rs = gains / (losses == 0 ? 1 : losses);
    final rsi = 100 - (100 / (1 + rs));

    if (rsi < 30) {
      final confidence = ((30 - rsi) / 30).clamp(0, 1).toDouble();
      return ModelSignal(signal: TradingSignal.buy, confidence: confidence);
    }
    if (rsi > 70) {
      final confidence = ((rsi - 70) / 30).clamp(0, 1).toDouble();
      return ModelSignal(signal: TradingSignal.sell, confidence: confidence);
    }
    return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
  }

  static ModelSignal _markovSignal(List<PriceEntry> history, double threshold) {
    if (history.length < 5) {
      return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
    }

    MarkovState _classify(double changePercent) {
      if (changePercent > threshold) return MarkovState.up;
      if (changePercent < -threshold) return MarkovState.down;
      return MarkovState.flat;
    }

    final transitions = <MarkovState, Map<MarkovState, int>>{};
    MarkovState? previous;

    for (int i = 1; i < history.length; i++) {
      final prev = history[i - 1].price;
      final curr = history[i].price;
      final changePercent = (curr - prev) / prev;
      final current = _classify(changePercent);
      final prevState = previous;
      if (prevState != null) {
        transitions.putIfAbsent(prevState, () => <MarkovState, int>{})
          ..update(current, (value) => value + 1, ifAbsent: () => 1);
      }
      previous = current;
    }

    final currentState = previous ?? MarkovState.flat;
    final counts = transitions[currentState];
    if (counts == null || counts.isEmpty) {
      return const ModelSignal(signal: TradingSignal.hold, confidence: 0);
    }

    final total = counts.values.fold<int>(0, (sum, value) => sum + value);
    final probUp = (counts[MarkovState.up] ?? 0) / total;
    final probDown = (counts[MarkovState.down] ?? 0) / total;
    final probFlat = (counts[MarkovState.flat] ?? 0) / total;

    if (probUp >= probDown && probUp >= probFlat) {
      return ModelSignal(signal: TradingSignal.buy, confidence: probUp);
    }
    if (probDown >= probUp && probDown >= probFlat) {
      return ModelSignal(signal: TradingSignal.sell, confidence: probDown);
    }
    return ModelSignal(signal: TradingSignal.hold, confidence: probFlat);
  }
}

enum MarkovState { up, down, flat }
