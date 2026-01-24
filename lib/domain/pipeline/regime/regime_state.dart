class RegimeState {
  const RegimeState({
    required this.probBull,
    required this.probFlat,
    required this.probBear,
    required this.estimatedLag,
  });

  final double probBull;
  final double probFlat;
  final double probBear;
  final Duration estimatedLag;

  static RegimeState neutral() => const RegimeState(
        probBull: 1 / 3,
        probFlat: 1 / 3,
        probBear: 1 / 3,
        estimatedLag: Duration.zero,
      );
}
