import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/features/inventory/data/inventory_repository.dart'
    as repo;
import 'package:prac1/src/features/batch/data/batch_providers.dart';

final inventoryDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryDao,
);

final inventoryBatchDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryBatchDao,
);

final inventoryRepoProvider = riverpod.Provider((ref) {
  return repo.InventoryRepository(
    ref.watch(inventoryDaoProvider),
    ref.watch(inventoryBatchDaoProvider),
  );
});

final inventoryListByBatchProvider =
    riverpod.StreamProvider.family<List<db.InventoryData>, int>((ref, batchId) {
      final repository = ref.watch(inventoryRepoProvider);
      return repository.fetchItemsForBatch(batchId);
    });

final exportCsvProvider = riverpod.Provider((ref) {
  final repo = ref.watch(inventoryRepoProvider);
  return (int batchId) => repo.generateCsvString(batchId);
});
