import 'package:drift/drift.dart' hide Batch;
import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/core/database/tables.dart' as tables;

part 'inventory.dao.g.dart';

@DriftAccessor(tables: [tables.Inventory, tables.InventoryBatch])
class InventoryDao extends DatabaseAccessor<db.AppDatabase>
    with _$InventoryDaoMixin {
  InventoryDao(super.db);

  db.$InventoryTable get inventoryTable => attachedDatabase.inventory;
  db.$InventoryBatchTable get batchTable => attachedDatabase.inventoryBatch;

  // --- CREATE ---
  Future<int> insertItem({required int batchId, required String qrCode}) {
    return into(inventoryTable).insert(
      db.InventoryCompanion.insert(
        batchId: batchId,
        qrCode: qrCode,
        scannedAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  // --- READ ---
  Future<List<db.InventoryData>> getItemsByBatch(int batchId) {
    return (select(
      inventoryTable,
    )..where((t) => t.batchId.equals(batchId))).get();
  }

  /// Get a single record by QR.
  Future<db.InventoryData?> getItemByQr(String qr) {
    return (select(
      inventoryTable,
    )..where((t) => t.qrCode.equals(qr))).getSingleOrNull();
  }

  // --- JOIN (The reason why we have both tables here) ---
  Future<List<TypedResult>> getItemsWithBatchInfo() {
    return select(inventoryTable).join([
      innerJoin(batchTable, batchTable.id.equalsExp(inventory.batchId)),
    ]).get();
  }

  // --- DELETE ---

  Future<int> deleteItem(int id) {
    return (delete(inventoryTable)..where((t) => t.id.equals(id))).go();
  }
}
