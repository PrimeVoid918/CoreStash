import 'package:drift/drift.dart';
import 'package:prac1/src/core/database/data_access_objects/inventory.dao.dart';
import 'package:prac1/src/core/database/data_access_objects/batch.dao.dart';
import 'package:prac1/src/core/database/app_database.dart' as db;

class InventoryRepository {
  final InventoryDao _inventoryDao;
  final InventoryBatchDao _batchDao;

  InventoryRepository(this._inventoryDao, this._batchDao);

  Future<void> saveScannedItem({
    required String qrCode,
    required int batchId,
  }) async {
    if (qrCode.isEmpty) throw Exception("Invalid QR Code");

    await _inventoryDao.insertItem(batchId: batchId, qrCode: qrCode);
  }

  // Future<List<db.InventoryData>> fetchItemsForBatch(int batchId) {
  //   return _inventoryDao.getItemsByBatch(batchId);
  // }
  Stream<List<db.InventoryData>> fetchItemsForBatch(int batchId) {
    return _inventoryDao.watchItemsByBatch(batchId);
  }

  Future<db.InventoryData?> fetchInventoryItem({required String qrCode}) {
    return _inventoryDao.getItemByQr(qrCode);
  }

  Future<String> generateCsvString(int batchId) async {
    // 1. Fetch the joined records from the database
    final List<TypedResult> rows = await _inventoryDao.getCsvExportData(
      batchId,
    );

    // 2. Initialize the CSV buffer with the column headers requested by the head
    final StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln('QR Code,Description,Date Scanned');

    // 3. Loop through results and map table fields safely
    for (final row in rows) {
      final item = row.readTable(_inventoryDao.inventory);
      final batch = row.readTable(_inventoryDao.inventoryBatch);

      // Escape any unexpected commas inside descriptions to keep CSV formatting intact
      final cleanDescription = batch.description.replaceAll('"', '""');

      // Write row strings down line by line
      csvBuffer.writeln(
        '"${item.qrCode}","$cleanDescription","${item.scannedAt}"',
      );
    }

    return csvBuffer.toString();
  }

  Future<bool> checkDuplicate({
    required String qrCode,
    required int batchId,
  }) async {
    // 1. Call the low-level DAO query
    final db.InventoryData? existingItem = await _inventoryDao.getItemInBatch(
      batchId: batchId,
      qrCode: qrCode,
    );

    // 2. Map the object to a clean boolean state
    // If existingItem is NOT null, it means it already exists in this batch!
    return existingItem != null;
  }

  Future<bool> deleteInventoryItem(int inventoryId) async {
    final rowsAffected = await _inventoryDao.deleteInventoryItem(inventoryId);
    return rowsAffected > 0;
  }
}
