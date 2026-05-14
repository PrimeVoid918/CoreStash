// lib/src/features/inventory/data/inventory_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/features/inventory/data/inventory_repository.dart'
    as repo;

// 1. The Database Singleton
final appDatabaseProvider = riverpod.Provider((ref) => db.AppDatabase());

// 2. The DAOs
final inventoryDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryDao,
);

// Note: Use the exact name from your AppDatabase getters
final inventoryBatchDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryBatchDao,
);

// 3. The Repository (Injecting BOTH DAOs)
final inventoryRepoProvider = riverpod.Provider((ref) {
  return repo.InventoryRepository(
    ref.watch(inventoryDaoProvider),
    ref.watch(inventoryBatchDaoProvider), // Corrected name
  );
});

// 4. The Data Stream
final inventoryListProvider = riverpod.FutureProvider<List<db.InventoryData>>((
  ref,
) {
  final repository = ref.watch(inventoryRepoProvider);
  // Using a dummy batch ID for now to test the chain
  return repository.fetchItemsForBatch(1);
});
