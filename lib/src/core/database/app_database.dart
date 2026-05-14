import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'tables.dart' as tables;
import 'data_access_objects/batch.dao.dart' as batch_dao;
import 'data_access_objects/inventory.dao.dart' as inventory_dao;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [tables.Inventory, tables.InventoryBatch],
  daos: [inventory_dao.InventoryDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(path.join(dir.path, 'inventory.sqlite'));

    return NativeDatabase(file);
  });
}
