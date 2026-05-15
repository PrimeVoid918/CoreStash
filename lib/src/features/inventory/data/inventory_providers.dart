import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/features/inventory/data/inventory_repository.dart'
    as repo;
// Import the database provider from your batch file to reuse the single instance
import 'package:prac1/src/features/batch/data/batch_providers.dart'
    show appDatabaseProvider;

// 1. Inventory-Specific DAOs
final inventoryDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryDao,
);

final inventoryBatchDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryBatchDao,
);

// 2. Inventory Repository (Injecting BOTH DAOs)
final inventoryRepoProvider = riverpod.Provider((ref) {
  return repo.InventoryRepository(
    ref.watch(inventoryDaoProvider),
    ref.watch(inventoryBatchDaoProvider),
  );
});

// 3. Service Layer: Fetch Items For a Specific Batch
// Using .family turns this into a dynamic method like: getItemsByBatchId(id)
final inventoryListByBatchProvider =
    riverpod.FutureProvider.family<List<db.InventoryData>, int>((
      ref,
      batchId,
    ) async {
      final repository = ref.watch(inventoryRepoProvider);
      return await repository.fetchItemsForBatch(batchId);
    });
