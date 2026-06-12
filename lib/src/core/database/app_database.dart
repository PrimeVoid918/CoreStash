import 'package:drift/drift.dart';

// engine selector:
import 'connection/connection_stub.dart'
    if (dart.library.ffi) 'connection/connection_native.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart';

import 'tables.dart';
import 'data_access_objects/batch.dao.dart';
import 'data_access_objects/inventory.dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Inventory, InventoryBatch],
  daos: [InventoryDao, InventoryBatchDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
