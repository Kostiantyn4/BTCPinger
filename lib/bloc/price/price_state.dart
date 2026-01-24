import 'package:equatable/equatable.dart';

import '../../models/price_entry.dart';
import '../../models/price_quote.dart';
import '../../utils/analytics.dart';

enum PriceStatus { initial, loading, success, failure }

class PriceState extends Equatable {
  const PriceState({
    this.status = PriceStatus.initial,
    this.quote,
    this.history = const [],
    this.sevenDayChange = 0,
    this.threeDayChange = 0,
    this.trendSignal = false,
    this.decisionResult,
    this.errorMessage,
  });

  final PriceStatus status;
  final PriceQuote? quote;
  final List<PriceEntry> history;
  final double sevenDayChange;
  final double threeDayChange;
  final bool trendSignal;
  final DecisionResult? decisionResult;
  final String? errorMessage;

  PriceState copyWith({
    PriceStatus? status,
    PriceQuote? quote,
    List<PriceEntry>? history,
    double? sevenDayChange,
    double? threeDayChange,
    bool? trendSignal,
    DecisionResult? decisionResult,
    String? errorMessage,
  }) {
    return PriceState(
      status: status ?? this.status,
      quote: quote ?? this.quote,
      history: history ?? this.history,
      sevenDayChange: sevenDayChange ?? this.sevenDayChange,
      threeDayChange: threeDayChange ?? this.threeDayChange,
      trendSignal: trendSignal ?? this.trendSignal,
      decisionResult: decisionResult ?? this.decisionResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        quote,
        history,
        sevenDayChange,
        threeDayChange,
        trendSignal,
        decisionResult,
        errorMessage,
      ];
}
