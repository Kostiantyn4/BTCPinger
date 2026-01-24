class ChangePointState {
  const ChangePointState({
    required this.probability,
    required this.lastDetected,
  });

  final double probability;
  final DateTime? lastDetected;

  static ChangePointState neutral() => const ChangePointState(
        probability: 0,
        lastDetected: null,
      );
}
