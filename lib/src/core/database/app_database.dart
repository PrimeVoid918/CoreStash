import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'tables.dart';
import 'data_access_objects/batch.dao.dart';
import 'data_access_objects/inventory.dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Inventory, InventoryBatch],
  daos: [InventoryDao, InventoryBatchDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File(path.join(dir.path, 'inventory.sqlite'));

    return NativeDatabase(file);
  });
}
