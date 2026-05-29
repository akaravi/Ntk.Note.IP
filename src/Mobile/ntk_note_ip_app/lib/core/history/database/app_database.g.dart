// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $IpHistoryRowsTable extends IpHistoryRows
    with TableInfo<$IpHistoryRowsTable, IpHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IpHistoryRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isIPv6Meta = const VerificationMeta('isIPv6');
  @override
  late final GeneratedColumn<bool> isIPv6 = GeneratedColumn<bool>(
    'is_i_pv6',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_i_pv6" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<String> recordedAt = GeneratedColumn<String>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta(
    'countryCode',
  );
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceLabelMeta = const VerificationMeta(
    'deviceLabel',
  );
  @override
  late final GeneratedColumn<String> deviceLabel = GeneratedColumn<String>(
    'device_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    address,
    isIPv6,
    recordedAt,
    scope,
    city,
    countryCode,
    deviceLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ip_history_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<IpHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('is_i_pv6')) {
      context.handle(
        _isIPv6Meta,
        isIPv6.isAcceptableOrUnknown(data['is_i_pv6']!, _isIPv6Meta),
      );
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(
          data['country_code']!,
          _countryCodeMeta,
        ),
      );
    }
    if (data.containsKey('device_label')) {
      context.handle(
        _deviceLabelMeta,
        deviceLabel.isAcceptableOrUnknown(
          data['device_label']!,
          _deviceLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IpHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IpHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      isIPv6: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_i_pv6'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recorded_at'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      ),
      deviceLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_label'],
      ),
    );
  }

  @override
  $IpHistoryRowsTable createAlias(String alias) {
    return $IpHistoryRowsTable(attachedDatabase, alias);
  }
}

class IpHistoryRow extends DataClass implements Insertable<IpHistoryRow> {
  final String id;
  final String address;
  final bool isIPv6;
  final String recordedAt;
  final String? scope;
  final String? city;
  final String? countryCode;
  final String? deviceLabel;
  const IpHistoryRow({
    required this.id,
    required this.address,
    required this.isIPv6,
    required this.recordedAt,
    this.scope,
    this.city,
    this.countryCode,
    this.deviceLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['address'] = Variable<String>(address);
    map['is_i_pv6'] = Variable<bool>(isIPv6);
    map['recorded_at'] = Variable<String>(recordedAt);
    if (!nullToAbsent || scope != null) {
      map['scope'] = Variable<String>(scope);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    if (!nullToAbsent || deviceLabel != null) {
      map['device_label'] = Variable<String>(deviceLabel);
    }
    return map;
  }

  IpHistoryRowsCompanion toCompanion(bool nullToAbsent) {
    return IpHistoryRowsCompanion(
      id: Value(id),
      address: Value(address),
      isIPv6: Value(isIPv6),
      recordedAt: Value(recordedAt),
      scope: scope == null && nullToAbsent
          ? const Value.absent()
          : Value(scope),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      countryCode: countryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(countryCode),
      deviceLabel: deviceLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceLabel),
    );
  }

  factory IpHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IpHistoryRow(
      id: serializer.fromJson<String>(json['id']),
      address: serializer.fromJson<String>(json['address']),
      isIPv6: serializer.fromJson<bool>(json['isIPv6']),
      recordedAt: serializer.fromJson<String>(json['recordedAt']),
      scope: serializer.fromJson<String?>(json['scope']),
      city: serializer.fromJson<String?>(json['city']),
      countryCode: serializer.fromJson<String?>(json['countryCode']),
      deviceLabel: serializer.fromJson<String?>(json['deviceLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'address': serializer.toJson<String>(address),
      'isIPv6': serializer.toJson<bool>(isIPv6),
      'recordedAt': serializer.toJson<String>(recordedAt),
      'scope': serializer.toJson<String?>(scope),
      'city': serializer.toJson<String?>(city),
      'countryCode': serializer.toJson<String?>(countryCode),
      'deviceLabel': serializer.toJson<String?>(deviceLabel),
    };
  }

  IpHistoryRow copyWith({
    String? id,
    String? address,
    bool? isIPv6,
    String? recordedAt,
    Value<String?> scope = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> countryCode = const Value.absent(),
    Value<String?> deviceLabel = const Value.absent(),
  }) => IpHistoryRow(
    id: id ?? this.id,
    address: address ?? this.address,
    isIPv6: isIPv6 ?? this.isIPv6,
    recordedAt: recordedAt ?? this.recordedAt,
    scope: scope.present ? scope.value : this.scope,
    city: city.present ? city.value : this.city,
    countryCode: countryCode.present ? countryCode.value : this.countryCode,
    deviceLabel: deviceLabel.present ? deviceLabel.value : this.deviceLabel,
  );
  IpHistoryRow copyWithCompanion(IpHistoryRowsCompanion data) {
    return IpHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      address: data.address.present ? data.address.value : this.address,
      isIPv6: data.isIPv6.present ? data.isIPv6.value : this.isIPv6,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      scope: data.scope.present ? data.scope.value : this.scope,
      city: data.city.present ? data.city.value : this.city,
      countryCode: data.countryCode.present
          ? data.countryCode.value
          : this.countryCode,
      deviceLabel: data.deviceLabel.present
          ? data.deviceLabel.value
          : this.deviceLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IpHistoryRow(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('isIPv6: $isIPv6, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('scope: $scope, ')
          ..write('city: $city, ')
          ..write('countryCode: $countryCode, ')
          ..write('deviceLabel: $deviceLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    address,
    isIPv6,
    recordedAt,
    scope,
    city,
    countryCode,
    deviceLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IpHistoryRow &&
          other.id == this.id &&
          other.address == this.address &&
          other.isIPv6 == this.isIPv6 &&
          other.recordedAt == this.recordedAt &&
          other.scope == this.scope &&
          other.city == this.city &&
          other.countryCode == this.countryCode &&
          other.deviceLabel == this.deviceLabel);
}

class IpHistoryRowsCompanion extends UpdateCompanion<IpHistoryRow> {
  final Value<String> id;
  final Value<String> address;
  final Value<bool> isIPv6;
  final Value<String> recordedAt;
  final Value<String?> scope;
  final Value<String?> city;
  final Value<String?> countryCode;
  final Value<String?> deviceLabel;
  final Value<int> rowid;
  const IpHistoryRowsCompanion({
    this.id = const Value.absent(),
    this.address = const Value.absent(),
    this.isIPv6 = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.scope = const Value.absent(),
    this.city = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.deviceLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IpHistoryRowsCompanion.insert({
    required String id,
    required String address,
    this.isIPv6 = const Value.absent(),
    required String recordedAt,
    this.scope = const Value.absent(),
    this.city = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.deviceLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       address = Value(address),
       recordedAt = Value(recordedAt);
  static Insertable<IpHistoryRow> custom({
    Expression<String>? id,
    Expression<String>? address,
    Expression<bool>? isIPv6,
    Expression<String>? recordedAt,
    Expression<String>? scope,
    Expression<String>? city,
    Expression<String>? countryCode,
    Expression<String>? deviceLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (address != null) 'address': address,
      if (isIPv6 != null) 'is_i_pv6': isIPv6,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (scope != null) 'scope': scope,
      if (city != null) 'city': city,
      if (countryCode != null) 'country_code': countryCode,
      if (deviceLabel != null) 'device_label': deviceLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IpHistoryRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? address,
    Value<bool>? isIPv6,
    Value<String>? recordedAt,
    Value<String?>? scope,
    Value<String?>? city,
    Value<String?>? countryCode,
    Value<String?>? deviceLabel,
    Value<int>? rowid,
  }) {
    return IpHistoryRowsCompanion(
      id: id ?? this.id,
      address: address ?? this.address,
      isIPv6: isIPv6 ?? this.isIPv6,
      recordedAt: recordedAt ?? this.recordedAt,
      scope: scope ?? this.scope,
      city: city ?? this.city,
      countryCode: countryCode ?? this.countryCode,
      deviceLabel: deviceLabel ?? this.deviceLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isIPv6.present) {
      map['is_i_pv6'] = Variable<bool>(isIPv6.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<String>(recordedAt.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (deviceLabel.present) {
      map['device_label'] = Variable<String>(deviceLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IpHistoryRowsCompanion(')
          ..write('id: $id, ')
          ..write('address: $address, ')
          ..write('isIPv6: $isIPv6, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('scope: $scope, ')
          ..write('city: $city, ')
          ..write('countryCode: $countryCode, ')
          ..write('deviceLabel: $deviceLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IpHistoryRowsTable ipHistoryRows = $IpHistoryRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [ipHistoryRows];
}

typedef $$IpHistoryRowsTableCreateCompanionBuilder =
    IpHistoryRowsCompanion Function({
      required String id,
      required String address,
      Value<bool> isIPv6,
      required String recordedAt,
      Value<String?> scope,
      Value<String?> city,
      Value<String?> countryCode,
      Value<String?> deviceLabel,
      Value<int> rowid,
    });
typedef $$IpHistoryRowsTableUpdateCompanionBuilder =
    IpHistoryRowsCompanion Function({
      Value<String> id,
      Value<String> address,
      Value<bool> isIPv6,
      Value<String> recordedAt,
      Value<String?> scope,
      Value<String?> city,
      Value<String?> countryCode,
      Value<String?> deviceLabel,
      Value<int> rowid,
    });

class $$IpHistoryRowsTableFilterComposer
    extends Composer<_$AppDatabase, $IpHistoryRowsTable> {
  $$IpHistoryRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIPv6 => $composableBuilder(
    column: $table.isIPv6,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceLabel => $composableBuilder(
    column: $table.deviceLabel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IpHistoryRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $IpHistoryRowsTable> {
  $$IpHistoryRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIPv6 => $composableBuilder(
    column: $table.isIPv6,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceLabel => $composableBuilder(
    column: $table.deviceLabel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IpHistoryRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IpHistoryRowsTable> {
  $$IpHistoryRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get isIPv6 =>
      $composableBuilder(column: $table.isIPv6, builder: (column) => column);

  GeneratedColumn<String> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
    column: $table.countryCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceLabel => $composableBuilder(
    column: $table.deviceLabel,
    builder: (column) => column,
  );
}

class $$IpHistoryRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IpHistoryRowsTable,
          IpHistoryRow,
          $$IpHistoryRowsTableFilterComposer,
          $$IpHistoryRowsTableOrderingComposer,
          $$IpHistoryRowsTableAnnotationComposer,
          $$IpHistoryRowsTableCreateCompanionBuilder,
          $$IpHistoryRowsTableUpdateCompanionBuilder,
          (
            IpHistoryRow,
            BaseReferences<_$AppDatabase, $IpHistoryRowsTable, IpHistoryRow>,
          ),
          IpHistoryRow,
          PrefetchHooks Function()
        > {
  $$IpHistoryRowsTableTableManager(_$AppDatabase db, $IpHistoryRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IpHistoryRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IpHistoryRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IpHistoryRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<bool> isIPv6 = const Value.absent(),
                Value<String> recordedAt = const Value.absent(),
                Value<String?> scope = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String?> deviceLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IpHistoryRowsCompanion(
                id: id,
                address: address,
                isIPv6: isIPv6,
                recordedAt: recordedAt,
                scope: scope,
                city: city,
                countryCode: countryCode,
                deviceLabel: deviceLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String address,
                Value<bool> isIPv6 = const Value.absent(),
                required String recordedAt,
                Value<String?> scope = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> countryCode = const Value.absent(),
                Value<String?> deviceLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IpHistoryRowsCompanion.insert(
                id: id,
                address: address,
                isIPv6: isIPv6,
                recordedAt: recordedAt,
                scope: scope,
                city: city,
                countryCode: countryCode,
                deviceLabel: deviceLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IpHistoryRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IpHistoryRowsTable,
      IpHistoryRow,
      $$IpHistoryRowsTableFilterComposer,
      $$IpHistoryRowsTableOrderingComposer,
      $$IpHistoryRowsTableAnnotationComposer,
      $$IpHistoryRowsTableCreateCompanionBuilder,
      $$IpHistoryRowsTableUpdateCompanionBuilder,
      (
        IpHistoryRow,
        BaseReferences<_$AppDatabase, $IpHistoryRowsTable, IpHistoryRow>,
      ),
      IpHistoryRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IpHistoryRowsTableTableManager get ipHistoryRows =>
      $$IpHistoryRowsTableTableManager(_db, _db.ipHistoryRows);
}
