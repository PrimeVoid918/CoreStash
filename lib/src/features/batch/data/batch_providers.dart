import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:corestash/src/core/database/app_database.dart' as db;
import 'package:corestash/src/features/batch/data/batch_repository.dart'
    as batch_repo;

// 1. Core Database Dependency (Shared across the app)
final appDatabaseProvider = riverpod.Provider((ref) => db.AppDatabase());

// 2. Batch-Specific DAO
final batchDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryBatchDao,
);

final inventoryDaoProvider = riverpod.Provider(
  (ref) => ref.watch(appDatabaseProvider).inventoryDao,
);

// 3. Batch Repository (Only gets its own DAO)
final batchRepoProvider = riverpod.Provider((ref) {
  return batch_repo.BatchRepository(
    ref.watch(batchDaoProvider),
    ref.watch(inventoryDaoProvider),
  );
});

// 4. Service Layer: Fetch All Batches (For your main screen)
final batchListProvider = riverpod.FutureProvider<List<db.InventoryBatchData>>((
  ref,
) async {
  final repository = ref.watch(batchRepoProvider);
  return await repository.fetchAllBatches();
});

final batchInfoProvider =
    riverpod.FutureProvider.family<db.InventoryBatchData?, int>((
      ref,
      batchId,
    ) async {
      final repository = ref.watch(batchRepoProvider);
      return await repository.fetchBatchInfo(batchId);
    });
