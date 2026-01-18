import 'package:equatable/equatable.dart';

abstract class PriceEvent extends Equatable {
  const PriceEvent();

  @override
  List<Object?> get props => [];
}

class PriceStarted extends PriceEvent {
  const PriceStarted();
}

class PriceManualRefreshRequested extends PriceEvent {
  const PriceManualRefreshRequested();
}
