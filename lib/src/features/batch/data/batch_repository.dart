import 'package:prac1/src/core/database/app_database.dart' as db;
import 'package:prac1/src/core/database/data_access_objects/batch.dao.dart' as batchDao;

class BatchRepository {
  final batchDao.InventoryBatchDao _batchDao;

  BatchRepository(this._batchDao);

  Future<void> createBatch({
    required String name,
    required String description,
  }) async {
    await _batchDao.createBatch(name: name, description: description);
  }

  Future<List<db.BatchData>> fetchBatchData(int batchId) {
    return _batchDao.get
  }
}
