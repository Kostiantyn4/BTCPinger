import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../domain/pipeline/decision/advanced_decision_engine.dart';
import '../../domain/pipeline/decision/payoff_matrix.dart';
import '../../models/price_entry.dart';
import '../../repository/price_repository.dart';
import '../../services/notification_service.dart';
import '../../utils/helpers.dart';
import 'price_event.dart';
import 'price_state.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  PriceBloc(
    this._repository,
    this._notificationService,
    this._decisionEngine,
  ) : super(const PriceState()) {
    on<PriceStarted>(_onStarted);
    on<PriceManualRefreshRequested>(_onManualRefresh);
  }

  final PriceRepository _repository;
  final NotificationService _notificationService;
  final AdvancedDecisionEngine _decisionEngine;
  Timer? _timer;

  Future<void> _onStarted(
    PriceStarted event,
    Emitter<PriceState> emit,
  ) async {
    emit(state.copyWith(status: PriceStatus.loading));
    await _loadData(emit, forceRefresh: true);
    _timer?.cancel();
    _timer = Timer.periodic(
      AppHelpers.seconds(10),
      (_) => add(const PriceManualRefreshRequested()),
    );
  }

  Future<void> _onManualRefresh(
    PriceManualRefreshRequested event,
    Emitter<PriceState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(
    Emitter<PriceState> emit, {
    bool forceRefresh = false,
  }) async {
    try {
      final quote = await _repository.fetchQuote();
      final history = await _repository.loadHistory(
        forceRefresh: forceRefresh,
      );

      final sevenDayChange = _calculateChange(history, 7);
      final threeDayChange = _calculateChange(history, 3);
      final trendSignal = _detectTrendSignal(history);
      final advancedDecision = await _decisionEngine.evaluate(
        days: 30,
        previousAction: state.advancedDecision?.decision.finalAction,
      );

      final previousDecision = state.advancedDecision?.decision.finalAction;
      final nextAction = advancedDecision.decision.finalAction;
      if (nextAction != TradingDecision.hold && nextAction != previousDecision) {
        await _notificationService.showDecisionNotification(
          decision: nextAction,
          confidence: advancedDecision.decision.confidence,
          priceUsd: quote.usd,
          expectedValue: advancedDecision.decision.expectedValue,
        );
      }

      emit(
        state.copyWith(
          status: PriceStatus.success,
          quote: quote,
          history: history,
          sevenDayChange: sevenDayChange,
          threeDayChange: threeDayChange,
          trendSignal: trendSignal,
          advancedDecision: advancedDecision,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PriceStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  double _calculateChange(List<PriceEntry> entries, int days) {
    if (entries.length < days) return 0;
    final latest = entries.last.price;
    final reference = entries[entries.length - days].price;
    return AppHelpers.calculatePercentageChange(reference, latest);
  }

  bool _detectTrendSignal(List<PriceEntry> entries) {
    if (entries.length < 4) return false;
    int streak = 0;
    for (int i = 1; i < entries.length; i++) {
      if (entries[i].price > entries[i - 1].price) {
        streak++;
      } else {
        streak = 0;
      }
      if (streak >= 3) {
        final drop =
            AppHelpers.calculatePercentageChange(entries[i].price, entries.last.price);
        if (drop <= -5) return true;
      }
    }
    return false;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _repository.dispose();
    return super.close();
  }
}
