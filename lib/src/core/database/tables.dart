import 'package:drift/drift.dart';

class InventoryBatch extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text()();

  TextColumn get name => text()();

  TextColumn get createdAt => text()();
}

class Inventory extends Table {
  IntColumn get id => integer().autoIncrement()();

  // IntColumn get batchId => integer().references(InventoryBatch, #id)();
  IntColumn get batchId =>
      integer().references(InventoryBatch, #id, onDelete: KeyAction.cascade)();

  TextColumn get qrCode => text().unique()();

  TextColumn get scannedAt => text()();
}
