import 'package:drift/drift.dart';
import 'package:prac1/src/core/database/app_database.dart';
import 'package:prac1/src/core/database/tables.dart';

part 'inventory.dao.g.dart';

@DriftAccessor(tables: [Inventory, InventoryBatch])
class InventoryDao extends DatabaseAccessor<AppDatabase>
    with _$InventoryDaoMixin {
  InventoryDao(super.db);

  // --- CREATE ---
  Future<int> insertItem({required int batchId, required String qrCode}) {
    return into(inventory).insert(
      InventoryCompanion.insert(
        batchId: batchId,
        qrCode: qrCode,
        scannedAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  // --- READ ---
  Future<List<InventoryData>> getItemsByBatch(int batchId) {
    return (select(inventory)..where((t) => t.batchId.equals(batchId))).get();
  }

  /// Get a single record by QR.
  Future<InventoryData?> getItemByQr(String qr) {
    return (select(
      inventory,
    )..where((t) => t.qrCode.equals(qr))).getSingleOrNull();
  }

  // --- JOIN (The reason why we have both tables here) ---
  Future<List<TypedResult>> getItemsWithBatchInfo() {
    return select(inventory).join([
      innerJoin(inventoryBatch, inventoryBatch.id.equalsExp(inventory.batchId)),
    ]).get();
  }

  // --- DELETE ---

  Future<int> deleteItem(int id) {
    return (delete(inventory)..where((t) => t.id.equals(id))).go();
  }
}
