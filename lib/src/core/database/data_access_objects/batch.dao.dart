import 'package:drift/drift.dart' hide Batch;
import "../app_database.dart";
import '../tables.dart';
part 'batch.dao.g.dart';

@DriftAccessor(tables: [InventoryBatch])
class InventoryBatchDao extends DatabaseAccessor<AppDatabase>
    with _$InventoryBatchDaoMixin {
  InventoryBatchDao(super.db);

  // -- create
  Future<int> createBatch({required String description, required String name}) {
    return into(inventoryBatch).insert(
      InventoryBatchCompanion.insert(
        name: name,
        description: description,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  // --- READ ---
  /// Get a specific batch by its ID
  Future<InventoryBatchData?> getBatchById(int id) {
    return (select(
      inventoryBatch,
    )..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  Future<InventoryBatchData?> getBatchInfoById(int id) {
    return (select(
      inventoryBatch,
    )..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  /// Get the full list of batches
  Future<List<InventoryBatchData>> getAllBatches() {
    return select(inventoryBatch).get();
  }

  // --- UPDATE ---
  Future<bool> updateBatch(InventoryBatchData entry) {
    return update(inventoryBatch).replace(entry);
  }

  // --- DELETE ---
  Future<int> deleteBatch(int id) {
    return (delete(inventoryBatch)..where((b) => b.id.equals(id))).go();
  }
}
