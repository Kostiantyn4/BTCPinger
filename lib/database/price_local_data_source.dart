import 'package:isar/isar.dart';

import '../models/price_entry.dart';
import 'entities/price_entry_entity.dart';
import 'isar_database.dart';

class PriceLocalDataSource {
  PriceLocalDataSource(this._database);

  final IsarDatabase _database;

  Future<void> replaceEntries({
    required String currency,
    required List<PriceEntry> entries,
  }) async {
    final isar = await _database.database;
    final entities = entries.map(PriceEntryEntity.fromModel).toList();

    await isar.writeTxn(() async {
      await isar.priceEntryEntitys
          .filter()
          .currencyEqualTo(currency)
          .deleteAll();
      if (entities.isNotEmpty) {
        await isar.priceEntryEntitys.putAll(entities);
      }
    });
  }

  Future<void> upsertEntry(PriceEntry entry) async {
    final isar = await _database.database;
    final entity = PriceEntryEntity.fromModel(entry);

    await isar.writeTxn(() async {
      await isar.priceEntryEntitys.put(entity);
    });
  }

  Future<List<PriceEntry>> getEntries({
    required String currency,
    int limit = 30,
  }) async {
    final isar = await _database.database;
    final entities = await isar.priceEntryEntitys
        .filter()
        .currencyEqualTo(currency)
        .sortByTimestampDesc()
        .limit(limit)
        .findAll();

    return entities.map((e) => e.toModel()).toList().reversed.toList();
  }

  Future<void> clearAll() async {
    final isar = await _database.database;
    await isar.writeTxn(() async {
      await isar.priceEntryEntitys.clear();
    });
  }
}
