import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/price/price_bloc.dart';
import '../bloc/price/price_state.dart';
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
                  _buildHeader(textTheme, state),
                  const SizedBox(height: 24),
                  _TrendCard(state: state),
                  const SizedBox(height: 24),
                  _buildChartSection(state),
                  const SizedBox(height: 24),
                  _buildChangeCard(state),
                  const SizedBox(height: 12),
                  _buildAlertText(state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme, PriceState state) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text(
                'Аналітика трендів',
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

  Widget _buildChartSection(PriceState state) {
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
                ? const Center(
                    child: CircularProgressIndicator(),
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
                    day.label,
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

  Widget _buildChangeCard(PriceState state) {
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
            'Зміна за останні 3 дні',
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
            'Семиденна: ${state.sevenDayChange.toStringAsFixed(2)}%',
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

  Widget _buildAlertText(PriceState state) {
    final message = state.trendSignal
        ? 'Ціна зростала 3 дні поспіль, а потім зафіксовано падіння — уважно слідкуйте за сигналом.'
        : 'Помітних критичних трендів не зафіксовано.';

    return Text(
      message,
      style: GoogleFonts.notoSans(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.state});

  final PriceState state;

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
            'Динаміка курсу за 7 днів',
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
                'Останні 7 днів',
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
  static const switchActive = Color(0xFFF2B90C);
}

enum DayLabel {
  first('1 день'),
  second('2 дні'),
  third('3 дні'),
  fourth('4 дні'),
  fifth('5 днів'),
  sixth('6 днів'),
  seventh('7 днів');

  const DayLabel(this.label);

  final String label;
}
