// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InventoryTable extends tables.Inventory
    with TableInfo<$InventoryTable, InventoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qrCodeMeta = const VerificationMeta('qrCode');
  @override
  late final GeneratedColumn<String> qrCode = GeneratedColumn<String>(
    'qr_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scannedAtMeta = const VerificationMeta(
    'scannedAt',
  );
  @override
  late final GeneratedColumn<String> scannedAt = GeneratedColumn<String>(
    'scanned_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, batchId, qrCode, scannedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('qr_code')) {
      context.handle(
        _qrCodeMeta,
        qrCode.isAcceptableOrUnknown(data['qr_code']!, _qrCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_qrCodeMeta);
    }
    if (data.containsKey('scanned_at')) {
      context.handle(
        _scannedAtMeta,
        scannedAt.isAcceptableOrUnknown(data['scanned_at']!, _scannedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_scannedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      )!,
      qrCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_code'],
      )!,
      scannedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scanned_at'],
      )!,
    );
  }

  @override
  $InventoryTable createAlias(String alias) {
    return $InventoryTable(attachedDatabase, alias);
  }
}

class InventoryData extends DataClass implements Insertable<InventoryData> {
  final int id;
  final int batchId;
  final String qrCode;
  final String scannedAt;
  const InventoryData({
    required this.id,
    required this.batchId,
    required this.qrCode,
    required this.scannedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['batch_id'] = Variable<int>(batchId);
    map['qr_code'] = Variable<String>(qrCode);
    map['scanned_at'] = Variable<String>(scannedAt);
    return map;
  }

  InventoryCompanion toCompanion(bool nullToAbsent) {
    return InventoryCompanion(
      id: Value(id),
      batchId: Value(batchId),
      qrCode: Value(qrCode),
      scannedAt: Value(scannedAt),
    );
  }

  factory InventoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryData(
      id: serializer.fromJson<int>(json['id']),
      batchId: serializer.fromJson<int>(json['batchId']),
      qrCode: serializer.fromJson<String>(json['qrCode']),
      scannedAt: serializer.fromJson<String>(json['scannedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batchId': serializer.toJson<int>(batchId),
      'qrCode': serializer.toJson<String>(qrCode),
      'scannedAt': serializer.toJson<String>(scannedAt),
    };
  }

  InventoryData copyWith({
    int? id,
    int? batchId,
    String? qrCode,
    String? scannedAt,
  }) => InventoryData(
    id: id ?? this.id,
    batchId: batchId ?? this.batchId,
    qrCode: qrCode ?? this.qrCode,
    scannedAt: scannedAt ?? this.scannedAt,
  );
  InventoryData copyWithCompanion(InventoryCompanion data) {
    return InventoryData(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      qrCode: data.qrCode.present ? data.qrCode.value : this.qrCode,
      scannedAt: data.scannedAt.present ? data.scannedAt.value : this.scannedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryData(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('qrCode: $qrCode, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, batchId, qrCode, scannedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryData &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.qrCode == this.qrCode &&
          other.scannedAt == this.scannedAt);
}

class InventoryCompanion extends UpdateCompanion<InventoryData> {
  final Value<int> id;
  final Value<int> batchId;
  final Value<String> qrCode;
  final Value<String> scannedAt;
  const InventoryCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.qrCode = const Value.absent(),
    this.scannedAt = const Value.absent(),
  });
  InventoryCompanion.insert({
    this.id = const Value.absent(),
    required int batchId,
    required String qrCode,
    required String scannedAt,
  }) : batchId = Value(batchId),
       qrCode = Value(qrCode),
       scannedAt = Value(scannedAt);
  static Insertable<InventoryData> custom({
    Expression<int>? id,
    Expression<int>? batchId,
    Expression<String>? qrCode,
    Expression<String>? scannedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (qrCode != null) 'qr_code': qrCode,
      if (scannedAt != null) 'scanned_at': scannedAt,
    });
  }

  InventoryCompanion copyWith({
    Value<int>? id,
    Value<int>? batchId,
    Value<String>? qrCode,
    Value<String>? scannedAt,
  }) {
    return InventoryCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      qrCode: qrCode ?? this.qrCode,
      scannedAt: scannedAt ?? this.scannedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (qrCode.present) {
      map['qr_code'] = Variable<String>(qrCode.value);
    }
    if (scannedAt.present) {
      map['scanned_at'] = Variable<String>(scannedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('qrCode: $qrCode, ')
          ..write('scannedAt: $scannedAt')
          ..write(')'))
        .toString();
  }
}

class $InventoryBatchTable extends tables.InventoryBatch
    with TableInfo<$InventoryBatchTable, InventoryBatchData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryBatchTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, description, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_batch';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryBatchData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryBatchData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryBatchData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $InventoryBatchTable createAlias(String alias) {
    return $InventoryBatchTable(attachedDatabase, alias);
  }
}

class InventoryBatchData extends DataClass
    implements Insertable<InventoryBatchData> {
  final int id;
  final String description;
  final String name;
  final String createdAt;
  const InventoryBatchData({
    required this.id,
    required this.description,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  InventoryBatchCompanion toCompanion(bool nullToAbsent) {
    return InventoryBatchCompanion(
      id: Value(id),
      description: Value(description),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory InventoryBatchData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryBatchData(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  InventoryBatchData copyWith({
    int? id,
    String? description,
    String? name,
    String? createdAt,
  }) => InventoryBatchData(
    id: id ?? this.id,
    description: description ?? this.description,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  InventoryBatchData copyWithCompanion(InventoryBatchCompanion data) {
    return InventoryBatchData(
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBatchData(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryBatchData &&
          other.id == this.id &&
          other.description == this.description &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class InventoryBatchCompanion extends UpdateCompanion<InventoryBatchData> {
  final Value<int> id;
  final Value<String> description;
  final Value<String> name;
  final Value<String> createdAt;
  const InventoryBatchCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InventoryBatchCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    required String name,
    required String createdAt,
  }) : description = Value(description),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<InventoryBatchData> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? name,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InventoryBatchCompanion copyWith({
    Value<int>? id,
    Value<String>? description,
    Value<String>? name,
    Value<String>? createdAt,
  }) {
    return InventoryBatchCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryBatchCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InventoryTable inventory = $InventoryTable(this);
  late final $InventoryBatchTable inventoryBatch = $InventoryBatchTable(this);
  late final inventory_dao.InventoryDao inventoryDao =
      inventory_dao.InventoryDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    inventory,
    inventoryBatch,
  ];
}

typedef $$InventoryTableCreateCompanionBuilder =
    InventoryCompanion Function({
      Value<int> id,
      required int batchId,
      required String qrCode,
      required String scannedAt,
    });
typedef $$InventoryTableUpdateCompanionBuilder =
    InventoryCompanion Function({
      Value<int> id,
      Value<int> batchId,
      Value<String> qrCode,
      Value<String> scannedAt,
    });

class $$InventoryTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryTable> {
  $$InventoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryTable> {
  $$InventoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batchId => $composableBuilder(
    column: $table.batchId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrCode => $composableBuilder(
    column: $table.qrCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scannedAt => $composableBuilder(
    column: $table.scannedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryTable> {
  $$InventoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<String> get qrCode =>
      $composableBuilder(column: $table.qrCode, builder: (column) => column);

  GeneratedColumn<String> get scannedAt =>
      $composableBuilder(column: $table.scannedAt, builder: (column) => column);
}

class $$InventoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryTable,
          InventoryData,
          $$InventoryTableFilterComposer,
          $$InventoryTableOrderingComposer,
          $$InventoryTableAnnotationComposer,
          $$InventoryTableCreateCompanionBuilder,
          $$InventoryTableUpdateCompanionBuilder,
          (
            InventoryData,
            BaseReferences<_$AppDatabase, $InventoryTable, InventoryData>,
          ),
          InventoryData,
          PrefetchHooks Function()
        > {
  $$InventoryTableTableManager(_$AppDatabase db, $InventoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> batchId = const Value.absent(),
                Value<String> qrCode = const Value.absent(),
                Value<String> scannedAt = const Value.absent(),
              }) => InventoryCompanion(
                id: id,
                batchId: batchId,
                qrCode: qrCode,
                scannedAt: scannedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int batchId,
                required String qrCode,
                required String scannedAt,
              }) => InventoryCompanion.insert(
                id: id,
                batchId: batchId,
                qrCode: qrCode,
                scannedAt: scannedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryTable,
      InventoryData,
      $$InventoryTableFilterComposer,
      $$InventoryTableOrderingComposer,
      $$InventoryTableAnnotationComposer,
      $$InventoryTableCreateCompanionBuilder,
      $$InventoryTableUpdateCompanionBuilder,
      (
        InventoryData,
        BaseReferences<_$AppDatabase, $InventoryTable, InventoryData>,
      ),
      InventoryData,
      PrefetchHooks Function()
    >;
typedef $$InventoryBatchTableCreateCompanionBuilder =
    InventoryBatchCompanion Function({
      Value<int> id,
      required String description,
      required String name,
      required String createdAt,
    });
typedef $$InventoryBatchTableUpdateCompanionBuilder =
    InventoryBatchCompanion Function({
      Value<int> id,
      Value<String> description,
      Value<String> name,
      Value<String> createdAt,
    });

class $$InventoryBatchTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryBatchTable> {
  $$InventoryBatchTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryBatchTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryBatchTable> {
  $$InventoryBatchTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryBatchTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryBatchTable> {
  $$InventoryBatchTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InventoryBatchTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryBatchTable,
          InventoryBatchData,
          $$InventoryBatchTableFilterComposer,
          $$InventoryBatchTableOrderingComposer,
          $$InventoryBatchTableAnnotationComposer,
          $$InventoryBatchTableCreateCompanionBuilder,
          $$InventoryBatchTableUpdateCompanionBuilder,
          (
            InventoryBatchData,
            BaseReferences<
              _$AppDatabase,
              $InventoryBatchTable,
              InventoryBatchData
            >,
          ),
          InventoryBatchData,
          PrefetchHooks Function()
        > {
  $$InventoryBatchTableTableManager(
    _$AppDatabase db,
    $InventoryBatchTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryBatchTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryBatchTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryBatchTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => InventoryBatchCompanion(
                id: id,
                description: description,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String description,
                required String name,
                required String createdAt,
              }) => InventoryBatchCompanion.insert(
                id: id,
                description: description,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryBatchTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryBatchTable,
      InventoryBatchData,
      $$InventoryBatchTableFilterComposer,
      $$InventoryBatchTableOrderingComposer,
      $$InventoryBatchTableAnnotationComposer,
      $$InventoryBatchTableCreateCompanionBuilder,
      $$InventoryBatchTableUpdateCompanionBuilder,
      (
        InventoryBatchData,
        BaseReferences<_$AppDatabase, $InventoryBatchTable, InventoryBatchData>,
      ),
      InventoryBatchData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InventoryTableTableManager get inventory =>
      $$InventoryTableTableManager(_db, _db.inventory);
  $$InventoryBatchTableTableManager get inventoryBatch =>
      $$InventoryBatchTableTableManager(_db, _db.inventoryBatch);
}
