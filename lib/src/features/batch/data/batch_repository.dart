import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/core/database/data_access_objects/batch.dao.dart'
    as inventory_batch_dao;

class BatchRepository {
  final inventory_batch_dao.InventoryBatchDao _batchDao;

  BatchRepository(this._batchDao);

  Future<void> createBatch({
    required String name,
    required String description,
  }) async {
    await _batchDao.createBatch(name: name, description: description);
  }

  Future<List<db.InventoryBatchData?>> fetchBatchData(int batchId) async {
    final list = await _batchDao.getBatchById(batchId);
    return [list];
  }

  Future<db.InventoryBatchData?> fetchBatchInfo(int batchId) async {
    final info = await _batchDao.getBatchInfoById(batchId);
    return info;
  }

  Future<List<db.InventoryBatchData>> fetchAllBatches() async {
    return await _batchDao.getAllBatches();
  }
}
