// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dao.dart';

// ignore_for_file: type=lint
mixin _$InventoryDaoMixin on DatabaseAccessor<db.AppDatabase> {
  $InventoryTable get inventory => attachedDatabase.inventory;
  $InventoryBatchTable get inventoryBatch => attachedDatabase.inventoryBatch;
  InventoryDaoManager get managers => InventoryDaoManager(this);
}

class InventoryDaoManager {
  final _$InventoryDaoMixin _db;
  InventoryDaoManager(this._db);
  $$InventoryTableTableManager get inventory =>
      $$InventoryTableTableManager(_db.attachedDatabase, _db.inventory);
  $$InventoryBatchTableTableManager get inventoryBatch =>
      $$InventoryBatchTableTableManager(
        _db.attachedDatabase,
        _db.inventoryBatch,
      );
}
