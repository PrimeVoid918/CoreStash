import 'package:drift/drift.dart';
import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/core/database/data_access_objects/batch.dao.dart'
    as inventory_batch_dao;
import 'package:prac1/src/core/database/data_access_objects/inventory.dao.dart'
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
    // 1. Grab the existing row state first
    final existingBatch = await _batchDao.getBatchInfoById(batchId);
    if (existingBatch == null) return false;

    // 2. Safely mutate only the fields you want to change using .copyWith
    final updatedEntry = existingBatch.copyWith(
      name: name,
      description: description,
    );

    // 3. Pass the full completed entry back into your current replace DAO function
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

  Future<String> generateCsvString(int batchId) async {
    // 1. Fetch the joined rows from your local batch DAO query
    final List<TypedResult> rows = await _batchDao.getCsvExportData(batchId);

    // 2. Initialize the CSV buffer with your column headers
    final StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln('QR Code, Batch Name,Description,Date Scanned');

    // 3. Loop through the records
    for (final row in rows) {
      // Use _batchDao to read the raw database column tables safely
      final item = row.readTable(_batchDao.inventory);
      final batch = row.readTable(_batchDao.inventoryBatch);

      // Clean up string values to prevent broken CSV syntax
      final cleanBatchName = batch.name.replaceAll('"', '""');
      final cleanDescription = batch.description.replaceAll('"', '""');
      final cleanQrCode = item.qrCode.replaceAll('"', '""');

      // 4. Write row lines down with the batch name as the first column!
      csvBuffer.writeln(
        '"$cleanQrCode","$cleanBatchName","$cleanDescription","${item.scannedAt}"',
      );
    }

    return csvBuffer.toString();
  }

  Future<List<db.InventoryBatchData>> fetchAllBatches() async {
    return await _batchDao.getAllBatches();
  }
}
