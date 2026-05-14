import 'package:drift/drift.dart' hide Batch;
import "../app_database.dart" as db;
import '../tables.dart' as tables;
part 'batch.dao.g.dart';

@DriftAccessor(tables: [tables.InventoryBatch])
class InventoryBatchDao extends DatabaseAccessor<db.AppDatabase>
    with _$InventoryBatchDaoMixin {
  InventoryBatchDao(super.db);

  db.$InventoryBatchTable get batchTable => attachedDatabase.inventoryBatch;

  // -- create
  Future<int> createBatch({required String description, required String name}) {
    return into(batchTable).insert(
      db.InventoryBatchCompanion.insert(
        name: name,
        description: description,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  // --- READ ---
  /// Get a specific batch by its ID
  Future<db.InventoryBatchData?> getBatchById(int id) {
    return (select(
      batchTable,
    )..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  /// Get the full list of batches
  Future<List<db.InventoryBatchData>> getAllBatches() {
    return select(batchTable).get();
  }

  // --- UPDATE ---
  Future<bool> updateBatch(db.InventoryBatchData entry) {
    return update(batchTable).replace(entry);
  }

  // --- DELETE ---
  Future<int> deleteBatch(int id) {
    return (delete(batchTable)..where((b) => b.id.equals(id))).go();
  }
}
