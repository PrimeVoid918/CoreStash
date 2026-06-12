import 'package:drift/drift.dart';
import 'package:corestash/src/core/database/app_database.dart';
import 'package:corestash/src/core/database/tables.dart';

part 'inventory.dao.g.dart';

@DriftAccessor(tables: [Inventory, InventoryBatch])
class InventoryDao extends DatabaseAccessor<AppDatabase>
    with _$InventoryDaoMixin {
  InventoryDao(super.db);

  // --- CREATE ---
  Future<int> insertItem({
    required int batchId,
    required String qrCode,
    DateTime? scannedAt,
  }) {
    return into(inventory).insert(
      InventoryCompanion.insert(
        batchId: batchId,
        qrCode: qrCode,
        scannedAt: scannedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // --- READ ---
  // Future<List<InventoryData>> getItemsByBatch(int batchId) {
  //   return (select(inventory)..where((t) => t.batchId.equals(batchId))).get();
  // } // depracted as it caches it, instead returns a Stream where drift does the refetch
  Stream<List<InventoryData>> watchItemsByBatch(int batchId) {
    return (select(inventory)..where((t) => t.batchId.equals(batchId))).watch();
  }

  /// Get a single record by QR.
  Future<InventoryData?> getItemByQr(String qr) {
    return (select(
      inventory,
    )..where((t) => t.qrCode.equals(qr))).getSingleOrNull();
  }

  Future<InventoryData?> getItemInBatch({
    required int batchId,
    required String qrCode,
  }) {
    return (select(inventory)
          ..where((t) => t.batchId.equals(batchId) & t.qrCode.equals(qrCode)))
        .getSingleOrNull();
  }

  // --- JOIN (The reason why we have both tables here) ---
  Future<List<TypedResult>> getItemsWithBatchInfo() {
    return select(inventory).join([
      innerJoin(inventoryBatch, inventoryBatch.id.equalsExp(inventory.batchId)),
    ]).get();
  }

  // --- DELETE ---

  Future<int> deleteInventoryItem(int id) {
    return (delete(inventory)..where((t) => t.id.equals(id))).go();
  }

  // ---- Export CSV ----
  Future<List<TypedResult>> getCsvExportData(int batchId) {
    return (select(inventory)..where((t) => t.batchId.equals(batchId))).join([
      innerJoin(inventoryBatch, inventoryBatch.id.equalsExp(inventory.batchId)),
    ]).get();
  }
}
