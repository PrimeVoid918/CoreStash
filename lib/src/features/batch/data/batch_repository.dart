import 'package:drift/drift.dart';
import 'package:corestash/src/core/database/app_database.dart' as db;
import 'package:corestash/src/core/database/data_access_objects/batch.dao.dart'
    as inventory_batch_dao;
import 'package:corestash/src/core/database/data_access_objects/inventory.dao.dart'
    as inventory_dao;

class BatchRepository {
  final inventory_batch_dao.InventoryBatchDao _batchDao;
  final inventory_dao.InventoryDao _inventoryDao;

  BatchRepository(this._batchDao, this._inventoryDao);

  Future<void> createBatch({
    required String name,
    required String description,
  }) async {
    await _batchDao.createBatch(name: name, description: description);
  }

  Future<bool> updateBatch({
    required int batchId,
    required String name,
    required String description,
  }) async {
    final existingBatch = await _batchDao.getBatchInfoById(batchId);
    if (existingBatch == null) return false;

    final updatedEntry = existingBatch.copyWith(
      name: name,
      description: description,
    );

    return await _batchDao.updateBatch(updatedEntry);
  }

  Future<bool> deleteBatch(int batchId) async {
    final rowsAffected = await _batchDao.deleteBatch(batchId);
    return rowsAffected > 0;
  }

  Future<List<db.InventoryBatchData?>> fetchBatchData(int batchId) async {
    final list = await _batchDao.getBatchById(batchId);
    return [list];
  }

  Future<db.InventoryBatchData?> fetchBatchInfo(int batchId) async {
    final info = await _batchDao.getBatchInfoById(batchId);
    return info;
  }

  Future<List<List<dynamic>>> generateCsvRows(int batchId) async {
    final List<TypedResult> rows = await _batchDao.getCsvExportData(batchId);

    final List<List<dynamic>> csvMatrix = [
      ['QR Code', 'Batch Name', 'Description', 'Date Scanned'],
    ];

    for (final row in rows) {
      final item = row.readTable(_batchDao.inventory);
      final batch = row.readTable(_batchDao.inventoryBatch);

      csvMatrix.add([
        item.qrCode,
        batch.name,
        batch.description,
        item.scannedAt,
      ]);
    }

    return csvMatrix;
  }

  Future<void> importBatchFromRows(List<List<dynamic>> rows) async {
    if (rows.length < 2) return;

    final String batchName = rows[1].length > 1
        ? rows[1][1]?.toString().trim() ?? "Imported Batch"
        : "Imported Batch";

    final String batchDescription = rows[1].length > 2
        ? rows[1][2]?.toString().trim() ?? ""
        : "";

    // Ensure the top-level transaction wrapper is awaited
    await _batchDao.db.transaction(() async {
      final int newBatchId = await _batchDao.createBatch(
        name: batchName.isNotEmpty ? batchName : "Imported Batch",
        description: batchDescription,
      );

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty || row[0] == null) continue;

        final String qrCode = row[0].toString().trim();
        if (qrCode.isEmpty) continue;

        // init a real DateTime object default value
        DateTime parsedScannedAt = DateTime.now();

        // check and parse the raw string from row[3] safely
        if (row.length > 3 && row[3] != null && row[3].toString().isNotEmpty) {
          parsedScannedAt =
              DateTime.tryParse(row[3].toString()) ?? DateTime.now();
        }

        await _inventoryDao.insertItem(
          batchId: newBatchId,
          qrCode: qrCode,
          scannedAt: parsedScannedAt,
        );
      }
    });
  }

  Future<List<db.InventoryBatchData>> fetchAllBatches() async {
    return await _batchDao.getAllBatches();
  }
}
