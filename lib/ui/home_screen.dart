import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/price/price_bloc.dart';
import '../bloc/price/price_state.dart';
import '../l10n/gen/localization.dart';
import '../utils/analytics.dart';
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
                style: GoogleFonts.spaceGrotesk(
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
                    style: GoogleFonts.spaceGrotesk(
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
    final decision = state.decisionResult;
    if (decision == null) {
      return const SizedBox.shrink();
    }

    String signalLabel;
    Color signalColor;
    switch (decision.signal) {
      case TradingSignal.buy:
        signalLabel = localization.decisionBuy;
        signalColor = _HomeColors.positive;
        break;
      case TradingSignal.sell:
        signalLabel = localization.decisionSell;
        signalColor = Colors.redAccent;
        break;
      default:
        signalLabel = localization.decisionHold;
        signalColor = _HomeColors.accent;
    }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                signalLabel,
                style: GoogleFonts.spaceGrotesk(
                  color: signalColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(decision.confidence * 100).toStringAsFixed(1)}%',
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...decision.components.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _resolveModelLabel(entry.key, localization),
                    style: GoogleFonts.notoSans(
                      color: _HomeColors.accent,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${entry.value.signal.name.toUpperCase()} · ${(entry.value.confidence * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

String _resolveModelLabel(String key, Localization localization) {
  switch (key) {
    case 'ma':
      return localization.modelLabelMa;
    case 'rsi':
      return localization.modelLabelRsi;
    case 'markov':
      return localization.modelLabelMarkov;
    default:
      return key.toUpperCase();
  }
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
