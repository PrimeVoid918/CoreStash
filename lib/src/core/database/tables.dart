import 'package:drift/drift.dart';

class InventoryBatch extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text()();

  TextColumn get name => text()();

  TextColumn get createdAt => text()();
}

class Inventory extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get batchId => integer().references(InventoryBatch, #id)();

  TextColumn get qrCode => text()();

  TextColumn get scannedAt => text()();
}
