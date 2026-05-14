import 'package:drift/drift.dart';

class Inventory extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get batchId => integer().references(Batch, #id)();

  TextColumn get qrCode => text()();

  TextColumn get scannedAt => text()();
}

class InventoryBatch extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get description => text()();

  TextColumn get name => text()();

  TextColumn get createdAt => text()();
}
