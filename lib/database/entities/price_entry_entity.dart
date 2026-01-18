import 'package:isar/isar.dart';

import 'package:btc_pinger/models/price_entry.dart';

part 'price_entry_entity.g.dart';

@collection
class PriceEntryEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  late double price;

  @Index()
  late String currency;

  PriceEntry toModel() => PriceEntry(
        timestamp: timestamp,
        price: price,
        currency: currency,
      );

  static PriceEntryEntity fromModel(PriceEntry entry) {
    return PriceEntryEntity()
      ..timestamp = entry.timestamp
      ..price = entry.price
      ..currency = entry.currency;
  }
}
