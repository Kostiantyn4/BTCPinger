enum MarketRegime { bull, flat, bear }

enum TradingDecision { buy, hold, sell }

class PayoffMatrix {
  PayoffMatrix(this._matrix);

  final Map<TradingDecision, Map<MarketRegime, double>> _matrix;

  double payoff(TradingDecision decision, MarketRegime regime) {
    return _matrix[decision]?[regime] ?? 0;
  }

  static PayoffMatrix defaultMatrix() => PayoffMatrix({
        TradingDecision.buy: {
          MarketRegime.bull: 100,
          MarketRegime.flat: -5,
          MarketRegime.bear: -300,
        },
        TradingDecision.hold: {
          MarketRegime.bull: -10,
          MarketRegime.flat: 0,
          MarketRegime.bear: -10,
        },
        TradingDecision.sell: {
          MarketRegime.bull: -200,
          MarketRegime.flat: 5,
          MarketRegime.bear: 150,
        },
      });
}
