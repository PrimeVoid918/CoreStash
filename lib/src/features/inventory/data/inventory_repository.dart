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

  Future<List<db.InventoryData>> fetchItemsForBatch(int batchId) {
    return _inventoryDao.getItemsByBatch(batchId);
  }
}
