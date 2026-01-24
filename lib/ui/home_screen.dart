import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/price/price_bloc.dart';
import '../bloc/price/price_state.dart';
import '../domain/pipeline/decision/payoff_matrix.dart';
import '../l10n/gen/localization.dart';
import '../utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = Localization.of(context);
    return Scaffold(
      backgroundColor: _HomeColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: BlocBuilder<PriceBloc, PriceState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(textTheme, state, localization),
                  const SizedBox(height: 24),
                  _TrendCard(state: state, localization: localization),
                  const SizedBox(height: 24),
                  _buildDecisionCard(state, localization),
                  const SizedBox(height: 24),
                  _buildChartSection(state, localization),
                  const SizedBox(height: 24),
                  _buildChangeCard(state, localization),
                  const SizedBox(height: 12),
                  _buildAlertText(state, localization),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, PriceState state, Localization localization) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text(
                localization.headerTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              if (state.quote != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${AppHelpers.formatPrice(state.quote!.usd)} / ${AppHelpers.formatPrice(state.quote!.uah, currency: 'UAH')}',
                    style: GoogleFonts.notoSans(
                      color: _HomeColors.accent,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 64),
      ],
    );
  }

  Widget _buildChartSection(PriceState state, Localization localization) {
    final history = state.history;
    final spots = List<FlSpot>.generate(
      history.length,
      (index) => FlSpot(index.toDouble(), history[index].price),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        color: _HomeColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: spots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(
                          localization.chartLoading,
                          style: GoogleFonts.notoSans(color: Colors.white70),
                        ),
                      ],
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minY: (spots.map((e) => e.y).fold<double>(
                                double.infinity,
                                (min, value) => value < min ? value : min,
                              ) -
                              2000)
                          .clamp(0, double.infinity),
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      lineTouchData: const LineTouchData(enabled: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: _HomeColors.accent,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                _HomeColors.accent.withValues(alpha: 0.2),
                                _HomeColors.accent.withValues(alpha: 0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: DayLabel.values
                .map(
                  (day) => Text(
                    day.label(localization),
                    style: GoogleFonts.notoSans(
                      color: _HomeColors.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.2,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeCard(PriceState state, Localization localization) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _HomeColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.changeCardTitle,
            style: GoogleFonts.notoSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.threeDayChange.toStringAsFixed(2)}%',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            localization
                .changeCardSevenDay('${state.sevenDayChange.toStringAsFixed(2)}%'),
            style: GoogleFonts.notoSans(
              color: state.sevenDayChange >= 0
                  ? _HomeColors.positive
                  : Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertText(PriceState state, Localization localization) {
    final message =
        state.trendSignal ? localization.alertTrendDetected : localization.alertNoTrend;

    return Text(
      message,
      style: GoogleFonts.notoSans(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  Widget _buildDecisionCard(PriceState state, Localization localization) {
    final advancedDecision = state.advancedDecision;
    if (advancedDecision == null) {
      return const SizedBox.shrink();
    }

    final decision = advancedDecision.decision;
    final signal = advancedDecision.signal;
    final regime = advancedDecision.context.regimeState;
    final changePoint = advancedDecision.context.changePointState;

    String signalLabel;
    Color signalColor;
    switch (decision.optimizedAction) {
      case TradingDecision.buy:
        signalLabel = localization.decisionBuy;
        signalColor = _HomeColors.positive;
        break;
      case TradingDecision.sell:
        signalLabel = localization.decisionSell;
        signalColor = Colors.redAccent;
        break;
      default:
        signalLabel = localization.decisionHold;
        signalColor = _HomeColors.accent;
    }

    final stats = [
      _DecisionStatData(
        label: localization.decisionEvLabel,
        value: decision.expectedValue.toStringAsFixed(1),
        hint: localization.decisionEvHint,
      ),
      _DecisionStatData(
        label: localization.decisionAdjustedLabel,
        value: decision.adjustedScore.toStringAsFixed(1),
        hint: localization.decisionAdjustedHint,
      ),
      _DecisionStatData(
        label: localization.decisionConfidenceLabel,
        value: '${(decision.confidence * 100).toStringAsFixed(1)}%',
        hint: localization.decisionConfidenceHint,
      ),
      _DecisionStatData(
        label: localization.decisionBaseSignalLabel,
        value: signal.base.toStringAsFixed(2),
        hint: localization.decisionBaseSignalHint,
      ),
      _DecisionStatData(
        label: localization.decisionModulatedSignalLabel,
        value: signal.modulated.toStringAsFixed(2),
        hint: localization.decisionModulatedSignalHint,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _HomeColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.decisionCardTitle,
            style: GoogleFonts.notoSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      signalLabel,
                      style: GoogleFonts.spaceGrotesk(
                        color: signalColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${localization.decisionConfidenceLabel}: ${(decision.confidence * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.notoSans(color: _HomeColors.accent),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    localization.decisionEvLabel,
                    style: GoogleFonts.notoSans(
                      color: _HomeColors.accent,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    decision.expectedValue.toStringAsFixed(1),
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            localization.decisionSignalSectionTitle,
            style: GoogleFonts.notoSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _DecisionStatGrid(stats: stats),
          const SizedBox(height: 16),
          Text(
            localization.decisionRegimeSectionTitle,
            style: GoogleFonts.notoSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _RegimeProbabilityRow(
            label: localization.decisionBullProbLabel,
            probability: regime.probBull,
            hint: localization.decisionBullProbHint,
            color: _HomeColors.positive,
          ),
          const SizedBox(height: 8),
          _RegimeProbabilityRow(
            label: localization.decisionFlatProbLabel,
            probability: regime.probFlat,
            hint: localization.decisionFlatProbHint,
            color: _HomeColors.accent,
          ),
          const SizedBox(height: 8),
          _RegimeProbabilityRow(
            label: localization.decisionBearProbLabel,
            probability: regime.probBear,
            hint: localization.decisionBearProbHint,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DecisionStat(
                  label: localization.decisionChangeProbLabel,
                  value: '${(changePoint.probability * 100).toStringAsFixed(1)}%',
                  hint: localization.decisionChangeProbHint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DecisionStat(
                  label: localization.decisionLagLabel,
                  value: localization
                      .decisionMinutes(decision.effectiveLag.inMinutes.toString()),
                  hint: localization.decisionLagHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DecisionStat(
            label: localization.decisionPenaltyLabel,
            value: decision.trace.lagPenaltyMultiplier.toStringAsFixed(2),
            hint: localization.decisionPenaltyHint,
          ),
          const SizedBox(height: 12),
          _DecisionStat(
            label: localization.decisionRawConfidenceLabel,
            value: '${(decision.trace.rawConfidence * 100).toStringAsFixed(1)}%',
            hint: localization.decisionRawConfidenceHint,
          ),
          const SizedBox(height: 12),
          _DecisionStat(
            label: localization.decisionCalibratedConfidenceLabel,
            value: '${(decision.trace.calibratedConfidence * 100).toStringAsFixed(1)}%',
            hint: localization.decisionCalibratedConfidenceHint,
          ),
          const SizedBox(height: 12),
          _DecisionStat(
            label: localization.decisionPrevActionLabel,
            value: decision.trace.previousAction != null
                ? _decisionLabel(decision.trace.previousAction!, localization)
                : '—',
            hint: localization.decisionPrevActionHint,
          ),
        ],
      ),
    );
  }
}

String _decisionLabel(TradingDecision action, Localization localization) {
  switch (action) {
    case TradingDecision.buy:
      return localization.decisionBuy;
    case TradingDecision.sell:
      return localization.decisionSell;
    case TradingDecision.hold:
      return localization.decisionHold;
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.state, required this.localization});

  final PriceState state;
  final Localization localization;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _HomeColors.card, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.trendCardTitle,
            style: GoogleFonts.notoSans(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.quote != null
                ? AppHelpers.formatPrice(state.quote!.usd)
                : '—',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                localization.trendCardSubtitle,
                style: GoogleFonts.notoSans(
                  color: _HomeColors.accent,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                state.sevenDayChange >= 0
                    ? '+${state.sevenDayChange.toStringAsFixed(2)}%'
                    : '${state.sevenDayChange.toStringAsFixed(2)}%',
                style: GoogleFonts.notoSans(
                  color:
                      state.sevenDayChange >= 0 ? _HomeColors.positive : Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeColors {
  static const background = Color(0xFF231E10);
  static const card = Color(0xFF493F22);
  static const accent = Color(0xFFCbbc90);
  static const positive = Color(0xFF0BDA1D);
}

enum DayLabel { first, second, third, fourth, fifth, sixth, seventh; }

class _DecisionStatGrid extends StatelessWidget {
  const _DecisionStatGrid({required this.stats});

  final List<_DecisionStatData> stats;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < stats.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(
              child: _DecisionStat(
                label: stats[i].label,
                value: stats[i].value,
                hint: stats[i].hint,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: i + 1 < stats.length
                  ? _DecisionStat(
                      label: stats[i + 1].label,
                      value: stats[i + 1].value,
                      hint: stats[i + 1].hint,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < stats.length) {
        rows.add(const SizedBox(height: 12));
      }
    }
    return Column(children: rows);
  }
}

class _DecisionStat extends StatelessWidget {
  const _DecisionStat({
    required this.label,
    required this.value,
    required this.hint,
  });

  final String label;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _HomeColors.card.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _HomeColors.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.notoSans(
                    color: _HomeColors.accent,
                    fontSize: 12,
                  ),
                ),
              ),
              Tooltip(
                message: hint,
                triggerMode: TooltipTriggerMode.tap,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: _HomeColors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegimeProbabilityRow extends StatelessWidget {
  const _RegimeProbabilityRow({
    required this.label,
    required this.probability,
    required this.hint,
    required this.color,
  });

  final String label;
  final double probability;
  final String hint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.notoSans(color: color, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Tooltip(
                message: hint,
                triggerMode: TooltipTriggerMode.tap,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: _HomeColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: probability.clamp(0, 1),
              backgroundColor: _HomeColors.card,
              color: color,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(probability * 100).toStringAsFixed(1)}%',
          style: GoogleFonts.notoSans(color: color, fontSize: 12),
        ),
      ],
    );
  }
}

class _DecisionStatData {
  const _DecisionStatData({
    required this.label,
    required this.value,
    required this.hint,
  });

  final String label;
  final String value;
  final String hint;
}

extension on DayLabel {
  String label(Localization localization) {
    switch (this) {
      case DayLabel.first:
        return localization.dayLabel1;
      case DayLabel.second:
        return localization.dayLabel2;
      case DayLabel.third:
        return localization.dayLabel3;
      case DayLabel.fourth:
        return localization.dayLabel4;
      case DayLabel.fifth:
        return localization.dayLabel5;
      case DayLabel.sixth:
        return localization.dayLabel6;
      case DayLabel.seventh:
        return localization.dayLabel7;
    }
  }
}
