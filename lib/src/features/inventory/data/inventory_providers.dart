import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
// Import your database and repository with aliases
import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/features/inventory/data/inventory_repository.dart'
    as repo;

/**
 * 1. DATABASE LAYER (The Root)
 */
// The single instance of your Drift database (Singleton)
final appDatabaseProvider = riverpod.Provider((ref) => db.AppDatabase());

/**
 * 2. DAO LAYER (The Specialized Workers)
 */
// Provide the DAOs specifically. This keeps the Repository focused.
final inventoryDaoProvider = riverpod.Provider((ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.inventoryDao; // Accessing the getter from app_database.dart
});

final batchDaoProvider = riverpod.Provider((ref) {
  final database = ref.watch(appDatabaseProvider);
  return database.batchDao;
});

/**
 * 3. REPOSITORY LAYER (The Bridge)
 */
final inventoryRepoProvider = riverpod.Provider((ref) {
  // We INJECT the DAOs into the Repository
  final inventoryDao = ref.watch(inventoryDaoProvider);
  final batchDao = ref.watch(batchDaoProvider);

  return repo.InventoryRepository(inventoryDao, batchDao);
});

/**
 * 4. DATA CONSUMPTION (The "Read" Side)
 */
final inventoryListProvider = riverpod.FutureProvider<List<db.InventoryData>>((
  ref,
) async {
  final repository = ref.watch(inventoryRepoProvider);

  // Assuming a default batch ID for your current practice
  return repository.fetchItemsForBatch(1);
});
