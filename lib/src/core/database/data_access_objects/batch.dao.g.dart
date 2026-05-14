// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch.dao.dart';

// ignore_for_file: type=lint
mixin _$InventoryBatchDaoMixin on DatabaseAccessor<db.AppDatabase> {
  $InventoryBatchTable get inventoryBatch => attachedDatabase.inventoryBatch;
  InventoryBatchDaoManager get managers => InventoryBatchDaoManager(this);
}

class InventoryBatchDaoManager {
  final _$InventoryBatchDaoMixin _db;
  InventoryBatchDaoManager(this._db);
  $$InventoryBatchTableTableManager get inventoryBatch =>
      $$InventoryBatchTableTableManager(
        _db.attachedDatabase,
        _db.inventoryBatch,
      );
}
