// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InterventionLogsTable extends InterventionLogs
    with TableInfo<$InterventionLogsTable, InterventionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterventionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _interventionMeta =
      const VerificationMeta('intervention');
  @override
  late final GeneratedColumn<String> intervention = GeneratedColumn<String>(
      'intervention', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
      'tier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggeredAtMeta =
      const VerificationMeta('triggeredAt');
  @override
  late final GeneratedColumn<int> triggeredAt = GeneratedColumn<int>(
      'triggered_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('triggered'));
  static const VerificationMeta _acknowledgedAtMeta =
      const VerificationMeta('acknowledgedAt');
  @override
  late final GeneratedColumn<int> acknowledgedAt = GeneratedColumn<int>(
      'acknowledged_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, intervention, tier, triggeredAt, status, acknowledgedAt, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intervention_logs';
  @override
  VerificationContext validateIntegrity(Insertable<InterventionLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('intervention')) {
      context.handle(
          _interventionMeta,
          intervention.isAcceptableOrUnknown(
              data['intervention']!, _interventionMeta));
    } else if (isInserting) {
      context.missing(_interventionMeta);
    }
    if (data.containsKey('tier')) {
      context.handle(
          _tierMeta, tier.isAcceptableOrUnknown(data['tier']!, _tierMeta));
    } else if (isInserting) {
      context.missing(_tierMeta);
    }
    if (data.containsKey('triggered_at')) {
      context.handle(
          _triggeredAtMeta,
          triggeredAt.isAcceptableOrUnknown(
              data['triggered_at']!, _triggeredAtMeta));
    } else if (isInserting) {
      context.missing(_triggeredAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('acknowledged_at')) {
      context.handle(
          _acknowledgedAtMeta,
          acknowledgedAt.isAcceptableOrUnknown(
              data['acknowledged_at']!, _acknowledgedAtMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InterventionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InterventionLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      intervention: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intervention'])!,
      tier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tier'])!,
      triggeredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}triggered_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      acknowledgedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}acknowledged_at']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $InterventionLogsTable createAlias(String alias) {
    return $InterventionLogsTable(attachedDatabase, alias);
  }
}

class InterventionLog extends DataClass implements Insertable<InterventionLog> {
  final String id;
  final String intervention;
  final String tier;
  final int triggeredAt;
  final String status;
  final int? acknowledgedAt;
  final int? syncedAt;
  const InterventionLog(
      {required this.id,
      required this.intervention,
      required this.tier,
      required this.triggeredAt,
      required this.status,
      this.acknowledgedAt,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['intervention'] = Variable<String>(intervention);
    map['tier'] = Variable<String>(tier);
    map['triggered_at'] = Variable<int>(triggeredAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || acknowledgedAt != null) {
      map['acknowledged_at'] = Variable<int>(acknowledgedAt);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<int>(syncedAt);
    }
    return map;
  }

  InterventionLogsCompanion toCompanion(bool nullToAbsent) {
    return InterventionLogsCompanion(
      id: Value(id),
      intervention: Value(intervention),
      tier: Value(tier),
      triggeredAt: Value(triggeredAt),
      status: Value(status),
      acknowledgedAt: acknowledgedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acknowledgedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory InterventionLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InterventionLog(
      id: serializer.fromJson<String>(json['id']),
      intervention: serializer.fromJson<String>(json['intervention']),
      tier: serializer.fromJson<String>(json['tier']),
      triggeredAt: serializer.fromJson<int>(json['triggeredAt']),
      status: serializer.fromJson<String>(json['status']),
      acknowledgedAt: serializer.fromJson<int?>(json['acknowledgedAt']),
      syncedAt: serializer.fromJson<int?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'intervention': serializer.toJson<String>(intervention),
      'tier': serializer.toJson<String>(tier),
      'triggeredAt': serializer.toJson<int>(triggeredAt),
      'status': serializer.toJson<String>(status),
      'acknowledgedAt': serializer.toJson<int?>(acknowledgedAt),
      'syncedAt': serializer.toJson<int?>(syncedAt),
    };
  }

  InterventionLog copyWith(
          {String? id,
          String? intervention,
          String? tier,
          int? triggeredAt,
          String? status,
          Value<int?> acknowledgedAt = const Value.absent(),
          Value<int?> syncedAt = const Value.absent()}) =>
      InterventionLog(
        id: id ?? this.id,
        intervention: intervention ?? this.intervention,
        tier: tier ?? this.tier,
        triggeredAt: triggeredAt ?? this.triggeredAt,
        status: status ?? this.status,
        acknowledgedAt:
            acknowledgedAt.present ? acknowledgedAt.value : this.acknowledgedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  InterventionLog copyWithCompanion(InterventionLogsCompanion data) {
    return InterventionLog(
      id: data.id.present ? data.id.value : this.id,
      intervention: data.intervention.present
          ? data.intervention.value
          : this.intervention,
      tier: data.tier.present ? data.tier.value : this.tier,
      triggeredAt:
          data.triggeredAt.present ? data.triggeredAt.value : this.triggeredAt,
      status: data.status.present ? data.status.value : this.status,
      acknowledgedAt: data.acknowledgedAt.present
          ? data.acknowledgedAt.value
          : this.acknowledgedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InterventionLog(')
          ..write('id: $id, ')
          ..write('intervention: $intervention, ')
          ..write('tier: $tier, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('status: $status, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, intervention, tier, triggeredAt, status, acknowledgedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InterventionLog &&
          other.id == this.id &&
          other.intervention == this.intervention &&
          other.tier == this.tier &&
          other.triggeredAt == this.triggeredAt &&
          other.status == this.status &&
          other.acknowledgedAt == this.acknowledgedAt &&
          other.syncedAt == this.syncedAt);
}

class InterventionLogsCompanion extends UpdateCompanion<InterventionLog> {
  final Value<String> id;
  final Value<String> intervention;
  final Value<String> tier;
  final Value<int> triggeredAt;
  final Value<String> status;
  final Value<int?> acknowledgedAt;
  final Value<int?> syncedAt;
  final Value<int> rowid;
  const InterventionLogsCompanion({
    this.id = const Value.absent(),
    this.intervention = const Value.absent(),
    this.tier = const Value.absent(),
    this.triggeredAt = const Value.absent(),
    this.status = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InterventionLogsCompanion.insert({
    required String id,
    required String intervention,
    required String tier,
    required int triggeredAt,
    this.status = const Value.absent(),
    this.acknowledgedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        intervention = Value(intervention),
        tier = Value(tier),
        triggeredAt = Value(triggeredAt);
  static Insertable<InterventionLog> custom({
    Expression<String>? id,
    Expression<String>? intervention,
    Expression<String>? tier,
    Expression<int>? triggeredAt,
    Expression<String>? status,
    Expression<int>? acknowledgedAt,
    Expression<int>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (intervention != null) 'intervention': intervention,
      if (tier != null) 'tier': tier,
      if (triggeredAt != null) 'triggered_at': triggeredAt,
      if (status != null) 'status': status,
      if (acknowledgedAt != null) 'acknowledged_at': acknowledgedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InterventionLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? intervention,
      Value<String>? tier,
      Value<int>? triggeredAt,
      Value<String>? status,
      Value<int?>? acknowledgedAt,
      Value<int?>? syncedAt,
      Value<int>? rowid}) {
    return InterventionLogsCompanion(
      id: id ?? this.id,
      intervention: intervention ?? this.intervention,
      tier: tier ?? this.tier,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      status: status ?? this.status,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (intervention.present) {
      map['intervention'] = Variable<String>(intervention.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (triggeredAt.present) {
      map['triggered_at'] = Variable<int>(triggeredAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (acknowledgedAt.present) {
      map['acknowledged_at'] = Variable<int>(acknowledgedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<int>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterventionLogsCompanion(')
          ..write('id: $id, ')
          ..write('intervention: $intervention, ')
          ..write('tier: $tier, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('status: $status, ')
          ..write('acknowledgedAt: $acknowledgedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonitoringSessionsTable extends MonitoringSessions
    with TableInfo<$MonitoringSessionsTable, MonitoringSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonitoringSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
      'started_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _avgStressProbMeta =
      const VerificationMeta('avgStressProb');
  @override
  late final GeneratedColumn<double> avgStressProb = GeneratedColumn<double>(
      'avg_stress_prob', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stressEventCountMeta =
      const VerificationMeta('stressEventCount');
  @override
  late final GeneratedColumn<int> stressEventCount = GeneratedColumn<int>(
      'stress_event_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _interventionCountMeta =
      const VerificationMeta('interventionCount');
  @override
  late final GeneratedColumn<int> interventionCount = GeneratedColumn<int>(
      'intervention_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        startedAt,
        endedAt,
        avgStressProb,
        stressEventCount,
        interventionCount,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monitoring_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<MonitoringSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    if (data.containsKey('avg_stress_prob')) {
      context.handle(
          _avgStressProbMeta,
          avgStressProb.isAcceptableOrUnknown(
              data['avg_stress_prob']!, _avgStressProbMeta));
    }
    if (data.containsKey('stress_event_count')) {
      context.handle(
          _stressEventCountMeta,
          stressEventCount.isAcceptableOrUnknown(
              data['stress_event_count']!, _stressEventCountMeta));
    }
    if (data.containsKey('intervention_count')) {
      context.handle(
          _interventionCountMeta,
          interventionCount.isAcceptableOrUnknown(
              data['intervention_count']!, _interventionCountMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonitoringSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonitoringSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ended_at']),
      avgStressProb: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_stress_prob']),
      stressEventCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}stress_event_count'])!,
      interventionCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}intervention_count'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $MonitoringSessionsTable createAlias(String alias) {
    return $MonitoringSessionsTable(attachedDatabase, alias);
  }
}

class MonitoringSession extends DataClass
    implements Insertable<MonitoringSession> {
  final String id;
  final int startedAt;
  final int? endedAt;
  final double? avgStressProb;
  final int stressEventCount;
  final int interventionCount;
  final int? syncedAt;
  const MonitoringSession(
      {required this.id,
      required this.startedAt,
      this.endedAt,
      this.avgStressProb,
      required this.stressEventCount,
      required this.interventionCount,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    if (!nullToAbsent || avgStressProb != null) {
      map['avg_stress_prob'] = Variable<double>(avgStressProb);
    }
    map['stress_event_count'] = Variable<int>(stressEventCount);
    map['intervention_count'] = Variable<int>(interventionCount);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<int>(syncedAt);
    }
    return map;
  }

  MonitoringSessionsCompanion toCompanion(bool nullToAbsent) {
    return MonitoringSessionsCompanion(
      id: Value(id),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      avgStressProb: avgStressProb == null && nullToAbsent
          ? const Value.absent()
          : Value(avgStressProb),
      stressEventCount: Value(stressEventCount),
      interventionCount: Value(interventionCount),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory MonitoringSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonitoringSession(
      id: serializer.fromJson<String>(json['id']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      avgStressProb: serializer.fromJson<double?>(json['avgStressProb']),
      stressEventCount: serializer.fromJson<int>(json['stressEventCount']),
      interventionCount: serializer.fromJson<int>(json['interventionCount']),
      syncedAt: serializer.fromJson<int?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'avgStressProb': serializer.toJson<double?>(avgStressProb),
      'stressEventCount': serializer.toJson<int>(stressEventCount),
      'interventionCount': serializer.toJson<int>(interventionCount),
      'syncedAt': serializer.toJson<int?>(syncedAt),
    };
  }

  MonitoringSession copyWith(
          {String? id,
          int? startedAt,
          Value<int?> endedAt = const Value.absent(),
          Value<double?> avgStressProb = const Value.absent(),
          int? stressEventCount,
          int? interventionCount,
          Value<int?> syncedAt = const Value.absent()}) =>
      MonitoringSession(
        id: id ?? this.id,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
        avgStressProb:
            avgStressProb.present ? avgStressProb.value : this.avgStressProb,
        stressEventCount: stressEventCount ?? this.stressEventCount,
        interventionCount: interventionCount ?? this.interventionCount,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  MonitoringSession copyWithCompanion(MonitoringSessionsCompanion data) {
    return MonitoringSession(
      id: data.id.present ? data.id.value : this.id,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      avgStressProb: data.avgStressProb.present
          ? data.avgStressProb.value
          : this.avgStressProb,
      stressEventCount: data.stressEventCount.present
          ? data.stressEventCount.value
          : this.stressEventCount,
      interventionCount: data.interventionCount.present
          ? data.interventionCount.value
          : this.interventionCount,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonitoringSession(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('avgStressProb: $avgStressProb, ')
          ..write('stressEventCount: $stressEventCount, ')
          ..write('interventionCount: $interventionCount, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, avgStressProb,
      stressEventCount, interventionCount, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonitoringSession &&
          other.id == this.id &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.avgStressProb == this.avgStressProb &&
          other.stressEventCount == this.stressEventCount &&
          other.interventionCount == this.interventionCount &&
          other.syncedAt == this.syncedAt);
}

class MonitoringSessionsCompanion extends UpdateCompanion<MonitoringSession> {
  final Value<String> id;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<double?> avgStressProb;
  final Value<int> stressEventCount;
  final Value<int> interventionCount;
  final Value<int?> syncedAt;
  final Value<int> rowid;
  const MonitoringSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.avgStressProb = const Value.absent(),
    this.stressEventCount = const Value.absent(),
    this.interventionCount = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonitoringSessionsCompanion.insert({
    required String id,
    required int startedAt,
    this.endedAt = const Value.absent(),
    this.avgStressProb = const Value.absent(),
    this.stressEventCount = const Value.absent(),
    this.interventionCount = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        startedAt = Value(startedAt);
  static Insertable<MonitoringSession> custom({
    Expression<String>? id,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<double>? avgStressProb,
    Expression<int>? stressEventCount,
    Expression<int>? interventionCount,
    Expression<int>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (avgStressProb != null) 'avg_stress_prob': avgStressProb,
      if (stressEventCount != null) 'stress_event_count': stressEventCount,
      if (interventionCount != null) 'intervention_count': interventionCount,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonitoringSessionsCompanion copyWith(
      {Value<String>? id,
      Value<int>? startedAt,
      Value<int?>? endedAt,
      Value<double?>? avgStressProb,
      Value<int>? stressEventCount,
      Value<int>? interventionCount,
      Value<int?>? syncedAt,
      Value<int>? rowid}) {
    return MonitoringSessionsCompanion(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      avgStressProb: avgStressProb ?? this.avgStressProb,
      stressEventCount: stressEventCount ?? this.stressEventCount,
      interventionCount: interventionCount ?? this.interventionCount,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (avgStressProb.present) {
      map['avg_stress_prob'] = Variable<double>(avgStressProb.value);
    }
    if (stressEventCount.present) {
      map['stress_event_count'] = Variable<int>(stressEventCount.value);
    }
    if (interventionCount.present) {
      map['intervention_count'] = Variable<int>(interventionCount.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<int>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonitoringSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('avgStressProb: $avgStressProb, ')
          ..write('stressEventCount: $stressEventCount, ')
          ..write('interventionCount: $interventionCount, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StressEventsTable extends StressEvents
    with TableInfo<$StressEventsTable, StressEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StressEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES monitoring_sessions (id)'));
  static const VerificationMeta _eventTypeMeta =
      const VerificationMeta('eventType');
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
      'event_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<int> occurredAt = GeneratedColumn<int>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stressClassMeta =
      const VerificationMeta('stressClass');
  @override
  late final GeneratedColumn<int> stressClass = GeneratedColumn<int>(
      'stress_class', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _probabilityMeta =
      const VerificationMeta('probability');
  @override
  late final GeneratedColumn<double> probability = GeneratedColumn<double>(
      'probability', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sessionId,
        eventType,
        occurredAt,
        stressClass,
        probability,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stress_events';
  @override
  VerificationContext validateIntegrity(Insertable<StressEvent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(_eventTypeMeta,
          eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta));
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('stress_class')) {
      context.handle(
          _stressClassMeta,
          stressClass.isAcceptableOrUnknown(
              data['stress_class']!, _stressClassMeta));
    }
    if (data.containsKey('probability')) {
      context.handle(
          _probabilityMeta,
          probability.isAcceptableOrUnknown(
              data['probability']!, _probabilityMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StressEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StressEvent(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      eventType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_type'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}occurred_at'])!,
      stressClass: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stress_class']),
      probability: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}probability']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $StressEventsTable createAlias(String alias) {
    return $StressEventsTable(attachedDatabase, alias);
  }
}

class StressEvent extends DataClass implements Insertable<StressEvent> {
  final String id;
  final String sessionId;
  final String eventType;
  final int occurredAt;
  final int? stressClass;
  final double? probability;
  final int? syncedAt;
  const StressEvent(
      {required this.id,
      required this.sessionId,
      required this.eventType,
      required this.occurredAt,
      this.stressClass,
      this.probability,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['event_type'] = Variable<String>(eventType);
    map['occurred_at'] = Variable<int>(occurredAt);
    if (!nullToAbsent || stressClass != null) {
      map['stress_class'] = Variable<int>(stressClass);
    }
    if (!nullToAbsent || probability != null) {
      map['probability'] = Variable<double>(probability);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<int>(syncedAt);
    }
    return map;
  }

  StressEventsCompanion toCompanion(bool nullToAbsent) {
    return StressEventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      eventType: Value(eventType),
      occurredAt: Value(occurredAt),
      stressClass: stressClass == null && nullToAbsent
          ? const Value.absent()
          : Value(stressClass),
      probability: probability == null && nullToAbsent
          ? const Value.absent()
          : Value(probability),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory StressEvent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StressEvent(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      occurredAt: serializer.fromJson<int>(json['occurredAt']),
      stressClass: serializer.fromJson<int?>(json['stressClass']),
      probability: serializer.fromJson<double?>(json['probability']),
      syncedAt: serializer.fromJson<int?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'eventType': serializer.toJson<String>(eventType),
      'occurredAt': serializer.toJson<int>(occurredAt),
      'stressClass': serializer.toJson<int?>(stressClass),
      'probability': serializer.toJson<double?>(probability),
      'syncedAt': serializer.toJson<int?>(syncedAt),
    };
  }

  StressEvent copyWith(
          {String? id,
          String? sessionId,
          String? eventType,
          int? occurredAt,
          Value<int?> stressClass = const Value.absent(),
          Value<double?> probability = const Value.absent(),
          Value<int?> syncedAt = const Value.absent()}) =>
      StressEvent(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        eventType: eventType ?? this.eventType,
        occurredAt: occurredAt ?? this.occurredAt,
        stressClass: stressClass.present ? stressClass.value : this.stressClass,
        probability: probability.present ? probability.value : this.probability,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  StressEvent copyWithCompanion(StressEventsCompanion data) {
    return StressEvent(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      stressClass:
          data.stressClass.present ? data.stressClass.value : this.stressClass,
      probability:
          data.probability.present ? data.probability.value : this.probability,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StressEvent(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('stressClass: $stressClass, ')
          ..write('probability: $probability, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, sessionId, eventType, occurredAt, stressClass, probability, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StressEvent &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.eventType == this.eventType &&
          other.occurredAt == this.occurredAt &&
          other.stressClass == this.stressClass &&
          other.probability == this.probability &&
          other.syncedAt == this.syncedAt);
}

class StressEventsCompanion extends UpdateCompanion<StressEvent> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> eventType;
  final Value<int> occurredAt;
  final Value<int?> stressClass;
  final Value<double?> probability;
  final Value<int?> syncedAt;
  final Value<int> rowid;
  const StressEventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.stressClass = const Value.absent(),
    this.probability = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StressEventsCompanion.insert({
    required String id,
    required String sessionId,
    required String eventType,
    required int occurredAt,
    this.stressClass = const Value.absent(),
    this.probability = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        eventType = Value(eventType),
        occurredAt = Value(occurredAt);
  static Insertable<StressEvent> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? eventType,
    Expression<int>? occurredAt,
    Expression<int>? stressClass,
    Expression<double>? probability,
    Expression<int>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (eventType != null) 'event_type': eventType,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (stressClass != null) 'stress_class': stressClass,
      if (probability != null) 'probability': probability,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StressEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<String>? eventType,
      Value<int>? occurredAt,
      Value<int?>? stressClass,
      Value<double?>? probability,
      Value<int?>? syncedAt,
      Value<int>? rowid}) {
    return StressEventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      eventType: eventType ?? this.eventType,
      occurredAt: occurredAt ?? this.occurredAt,
      stressClass: stressClass ?? this.stressClass,
      probability: probability ?? this.probability,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<int>(occurredAt.value);
    }
    if (stressClass.present) {
      map['stress_class'] = Variable<int>(stressClass.value);
    }
    if (probability.present) {
      map['probability'] = Variable<double>(probability.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<int>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StressEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('stressClass: $stressClass, ')
          ..write('probability: $probability, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferenceWeightsTable extends PreferenceWeights
    with TableInfo<$PreferenceWeightsTable, PreferenceWeight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferenceWeightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _interventionMeta =
      const VerificationMeta('intervention');
  @override
  late final GeneratedColumn<String> intervention = GeneratedColumn<String>(
      'intervention', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [intervention, weight, updatedAt, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference_weights';
  @override
  VerificationContext validateIntegrity(Insertable<PreferenceWeight> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('intervention')) {
      context.handle(
          _interventionMeta,
          intervention.isAcceptableOrUnknown(
              data['intervention']!, _interventionMeta));
    } else if (isInserting) {
      context.missing(_interventionMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {intervention};
  @override
  PreferenceWeight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferenceWeight(
      intervention: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}intervention'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $PreferenceWeightsTable createAlias(String alias) {
    return $PreferenceWeightsTable(attachedDatabase, alias);
  }
}

class PreferenceWeight extends DataClass
    implements Insertable<PreferenceWeight> {
  final String intervention;
  final double weight;
  final int updatedAt;
  final int? syncedAt;
  const PreferenceWeight(
      {required this.intervention,
      required this.weight,
      required this.updatedAt,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['intervention'] = Variable<String>(intervention);
    map['weight'] = Variable<double>(weight);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<int>(syncedAt);
    }
    return map;
  }

  PreferenceWeightsCompanion toCompanion(bool nullToAbsent) {
    return PreferenceWeightsCompanion(
      intervention: Value(intervention),
      weight: Value(weight),
      updatedAt: Value(updatedAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PreferenceWeight.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferenceWeight(
      intervention: serializer.fromJson<String>(json['intervention']),
      weight: serializer.fromJson<double>(json['weight']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      syncedAt: serializer.fromJson<int?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'intervention': serializer.toJson<String>(intervention),
      'weight': serializer.toJson<double>(weight),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'syncedAt': serializer.toJson<int?>(syncedAt),
    };
  }

  PreferenceWeight copyWith(
          {String? intervention,
          double? weight,
          int? updatedAt,
          Value<int?> syncedAt = const Value.absent()}) =>
      PreferenceWeight(
        intervention: intervention ?? this.intervention,
        weight: weight ?? this.weight,
        updatedAt: updatedAt ?? this.updatedAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  PreferenceWeight copyWithCompanion(PreferenceWeightsCompanion data) {
    return PreferenceWeight(
      intervention: data.intervention.present
          ? data.intervention.value
          : this.intervention,
      weight: data.weight.present ? data.weight.value : this.weight,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceWeight(')
          ..write('intervention: $intervention, ')
          ..write('weight: $weight, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(intervention, weight, updatedAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferenceWeight &&
          other.intervention == this.intervention &&
          other.weight == this.weight &&
          other.updatedAt == this.updatedAt &&
          other.syncedAt == this.syncedAt);
}

class PreferenceWeightsCompanion extends UpdateCompanion<PreferenceWeight> {
  final Value<String> intervention;
  final Value<double> weight;
  final Value<int> updatedAt;
  final Value<int?> syncedAt;
  final Value<int> rowid;
  const PreferenceWeightsCompanion({
    this.intervention = const Value.absent(),
    this.weight = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferenceWeightsCompanion.insert({
    required String intervention,
    this.weight = const Value.absent(),
    required int updatedAt,
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : intervention = Value(intervention),
        updatedAt = Value(updatedAt);
  static Insertable<PreferenceWeight> custom({
    Expression<String>? intervention,
    Expression<double>? weight,
    Expression<int>? updatedAt,
    Expression<int>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (intervention != null) 'intervention': intervention,
      if (weight != null) 'weight': weight,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferenceWeightsCompanion copyWith(
      {Value<String>? intervention,
      Value<double>? weight,
      Value<int>? updatedAt,
      Value<int?>? syncedAt,
      Value<int>? rowid}) {
    return PreferenceWeightsCompanion(
      intervention: intervention ?? this.intervention,
      weight: weight ?? this.weight,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (intervention.present) {
      map['intervention'] = Variable<String>(intervention.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<int>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferenceWeightsCompanion(')
          ..write('intervention: $intervention, ')
          ..write('weight: $weight, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalibrationStatsTable extends CalibrationStats
    with TableInfo<$CalibrationStatsTable, CalibrationStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalibrationStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _calibratedAtMeta =
      const VerificationMeta('calibratedAt');
  @override
  late final GeneratedColumn<int> calibratedAt = GeneratedColumn<int>(
      'calibrated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<double>, String> means =
      GeneratedColumn<String>('means', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<double>>($CalibrationStatsTable.$convertermeans);
  @override
  late final GeneratedColumnWithTypeConverter<List<double>, String> stds =
      GeneratedColumn<String>('stds', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<double>>($CalibrationStatsTable.$converterstds);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<int> syncedAt = GeneratedColumn<int>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, calibratedAt, means, stds, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calibration_stats';
  @override
  VerificationContext validateIntegrity(Insertable<CalibrationStat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('calibrated_at')) {
      context.handle(
          _calibratedAtMeta,
          calibratedAt.isAcceptableOrUnknown(
              data['calibrated_at']!, _calibratedAtMeta));
    } else if (isInserting) {
      context.missing(_calibratedAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalibrationStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalibrationStat(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      calibratedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calibrated_at'])!,
      means: $CalibrationStatsTable.$convertermeans.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}means'])!),
      stds: $CalibrationStatsTable.$converterstds.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stds'])!),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $CalibrationStatsTable createAlias(String alias) {
    return $CalibrationStatsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<double>, String> $convertermeans =
      const DoubleListConverter();
  static TypeConverter<List<double>, String> $converterstds =
      const DoubleListConverter();
}

class CalibrationStat extends DataClass implements Insertable<CalibrationStat> {
  final int id;
  final int calibratedAt;
  final List<double> means;
  final List<double> stds;
  final int? syncedAt;
  const CalibrationStat(
      {required this.id,
      required this.calibratedAt,
      required this.means,
      required this.stds,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['calibrated_at'] = Variable<int>(calibratedAt);
    {
      map['means'] =
          Variable<String>($CalibrationStatsTable.$convertermeans.toSql(means));
    }
    {
      map['stds'] =
          Variable<String>($CalibrationStatsTable.$converterstds.toSql(stds));
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<int>(syncedAt);
    }
    return map;
  }

  CalibrationStatsCompanion toCompanion(bool nullToAbsent) {
    return CalibrationStatsCompanion(
      id: Value(id),
      calibratedAt: Value(calibratedAt),
      means: Value(means),
      stds: Value(stds),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CalibrationStat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalibrationStat(
      id: serializer.fromJson<int>(json['id']),
      calibratedAt: serializer.fromJson<int>(json['calibratedAt']),
      means: serializer.fromJson<List<double>>(json['means']),
      stds: serializer.fromJson<List<double>>(json['stds']),
      syncedAt: serializer.fromJson<int?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'calibratedAt': serializer.toJson<int>(calibratedAt),
      'means': serializer.toJson<List<double>>(means),
      'stds': serializer.toJson<List<double>>(stds),
      'syncedAt': serializer.toJson<int?>(syncedAt),
    };
  }

  CalibrationStat copyWith(
          {int? id,
          int? calibratedAt,
          List<double>? means,
          List<double>? stds,
          Value<int?> syncedAt = const Value.absent()}) =>
      CalibrationStat(
        id: id ?? this.id,
        calibratedAt: calibratedAt ?? this.calibratedAt,
        means: means ?? this.means,
        stds: stds ?? this.stds,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  CalibrationStat copyWithCompanion(CalibrationStatsCompanion data) {
    return CalibrationStat(
      id: data.id.present ? data.id.value : this.id,
      calibratedAt: data.calibratedAt.present
          ? data.calibratedAt.value
          : this.calibratedAt,
      means: data.means.present ? data.means.value : this.means,
      stds: data.stds.present ? data.stds.value : this.stds,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationStat(')
          ..write('id: $id, ')
          ..write('calibratedAt: $calibratedAt, ')
          ..write('means: $means, ')
          ..write('stds: $stds, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, calibratedAt, means, stds, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalibrationStat &&
          other.id == this.id &&
          other.calibratedAt == this.calibratedAt &&
          other.means == this.means &&
          other.stds == this.stds &&
          other.syncedAt == this.syncedAt);
}

class CalibrationStatsCompanion extends UpdateCompanion<CalibrationStat> {
  final Value<int> id;
  final Value<int> calibratedAt;
  final Value<List<double>> means;
  final Value<List<double>> stds;
  final Value<int?> syncedAt;
  const CalibrationStatsCompanion({
    this.id = const Value.absent(),
    this.calibratedAt = const Value.absent(),
    this.means = const Value.absent(),
    this.stds = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  CalibrationStatsCompanion.insert({
    this.id = const Value.absent(),
    required int calibratedAt,
    required List<double> means,
    required List<double> stds,
    this.syncedAt = const Value.absent(),
  })  : calibratedAt = Value(calibratedAt),
        means = Value(means),
        stds = Value(stds);
  static Insertable<CalibrationStat> custom({
    Expression<int>? id,
    Expression<int>? calibratedAt,
    Expression<String>? means,
    Expression<String>? stds,
    Expression<int>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calibratedAt != null) 'calibrated_at': calibratedAt,
      if (means != null) 'means': means,
      if (stds != null) 'stds': stds,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  CalibrationStatsCompanion copyWith(
      {Value<int>? id,
      Value<int>? calibratedAt,
      Value<List<double>>? means,
      Value<List<double>>? stds,
      Value<int?>? syncedAt}) {
    return CalibrationStatsCompanion(
      id: id ?? this.id,
      calibratedAt: calibratedAt ?? this.calibratedAt,
      means: means ?? this.means,
      stds: stds ?? this.stds,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (calibratedAt.present) {
      map['calibrated_at'] = Variable<int>(calibratedAt.value);
    }
    if (means.present) {
      map['means'] = Variable<String>(
          $CalibrationStatsTable.$convertermeans.toSql(means.value));
    }
    if (stds.present) {
      map['stds'] = Variable<String>(
          $CalibrationStatsTable.$converterstds.toSql(stds.value));
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<int>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalibrationStatsCompanion(')
          ..write('id: $id, ')
          ..write('calibratedAt: $calibratedAt, ')
          ..write('means: $means, ')
          ..write('stds: $stds, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InterventionLogsTable interventionLogs =
      $InterventionLogsTable(this);
  late final $MonitoringSessionsTable monitoringSessions =
      $MonitoringSessionsTable(this);
  late final $StressEventsTable stressEvents = $StressEventsTable(this);
  late final $PreferenceWeightsTable preferenceWeights =
      $PreferenceWeightsTable(this);
  late final $CalibrationStatsTable calibrationStats =
      $CalibrationStatsTable(this);
  late final InterventionLogDao interventionLogDao =
      InterventionLogDao(this as AppDatabase);
  late final MonitoringSessionDao monitoringSessionDao =
      MonitoringSessionDao(this as AppDatabase);
  late final StressEventDao stressEventDao =
      StressEventDao(this as AppDatabase);
  late final PreferenceWeightsDao preferenceWeightsDao =
      PreferenceWeightsDao(this as AppDatabase);
  late final CalibrationStatsDao calibrationStatsDao =
      CalibrationStatsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        interventionLogs,
        monitoringSessions,
        stressEvents,
        preferenceWeights,
        calibrationStats
      ];
}

typedef $$InterventionLogsTableCreateCompanionBuilder
    = InterventionLogsCompanion Function({
  required String id,
  required String intervention,
  required String tier,
  required int triggeredAt,
  Value<String> status,
  Value<int?> acknowledgedAt,
  Value<int?> syncedAt,
  Value<int> rowid,
});
typedef $$InterventionLogsTableUpdateCompanionBuilder
    = InterventionLogsCompanion Function({
  Value<String> id,
  Value<String> intervention,
  Value<String> tier,
  Value<int> triggeredAt,
  Value<String> status,
  Value<int?> acknowledgedAt,
  Value<int?> syncedAt,
  Value<int> rowid,
});

class $$InterventionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $InterventionLogsTable> {
  $$InterventionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get intervention => $composableBuilder(
      column: $table.intervention, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get triggeredAt => $composableBuilder(
      column: $table.triggeredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$InterventionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $InterventionLogsTable> {
  $$InterventionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get intervention => $composableBuilder(
      column: $table.intervention,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get triggeredAt => $composableBuilder(
      column: $table.triggeredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$InterventionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterventionLogsTable> {
  $$InterventionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get intervention => $composableBuilder(
      column: $table.intervention, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get triggeredAt => $composableBuilder(
      column: $table.triggeredAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get acknowledgedAt => $composableBuilder(
      column: $table.acknowledgedAt, builder: (column) => column);

  GeneratedColumn<int> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$InterventionLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InterventionLogsTable,
    InterventionLog,
    $$InterventionLogsTableFilterComposer,
    $$InterventionLogsTableOrderingComposer,
    $$InterventionLogsTableAnnotationComposer,
    $$InterventionLogsTableCreateCompanionBuilder,
    $$InterventionLogsTableUpdateCompanionBuilder,
    (
      InterventionLog,
      BaseReferences<_$AppDatabase, $InterventionLogsTable, InterventionLog>
    ),
    InterventionLog,
    PrefetchHooks Function()> {
  $$InterventionLogsTableTableManager(
      _$AppDatabase db, $InterventionLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterventionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterventionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterventionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> intervention = const Value.absent(),
            Value<String> tier = const Value.absent(),
            Value<int> triggeredAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> acknowledgedAt = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InterventionLogsCompanion(
            id: id,
            intervention: intervention,
            tier: tier,
            triggeredAt: triggeredAt,
            status: status,
            acknowledgedAt: acknowledgedAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String intervention,
            required String tier,
            required int triggeredAt,
            Value<String> status = const Value.absent(),
            Value<int?> acknowledgedAt = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InterventionLogsCompanion.insert(
            id: id,
            intervention: intervention,
            tier: tier,
            triggeredAt: triggeredAt,
            status: status,
            acknowledgedAt: acknowledgedAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$InterventionLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InterventionLogsTable,
    InterventionLog,
    $$InterventionLogsTableFilterComposer,
    $$InterventionLogsTableOrderingComposer,
    $$InterventionLogsTableAnnotationComposer,
    $$InterventionLogsTableCreateCompanionBuilder,
    $$InterventionLogsTableUpdateCompanionBuilder,
    (
      InterventionLog,
      BaseReferences<_$AppDatabase, $InterventionLogsTable, InterventionLog>
    ),
    InterventionLog,
    PrefetchHooks Function()>;
typedef $$MonitoringSessionsTableCreateCompanionBuilder
    = MonitoringSessionsCompanion Function({
  required String id,
  required int startedAt,
  Value<int?> endedAt,
  Value<double?> avgStressProb,
  Value<int> stressEventCount,
  Value<int> interventionCount,
  Value<int?> syncedAt,
  Value<int> rowid,
});
typedef $$MonitoringSessionsTableUpdateCompanionBuilder
    = MonitoringSessionsCompanion Function({
  Value<String> id,
  Value<int> startedAt,
  Value<int?> endedAt,
  Value<double?> avgStressProb,
  Value<int> stressEventCount,
  Value<int> interventionCount,
  Value<int?> syncedAt,
  Value<int> rowid,
});

final class $$MonitoringSessionsTableReferences extends BaseReferences<
    _$AppDatabase, $MonitoringSessionsTable, MonitoringSession> {
  $$MonitoringSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StressEventsTable, List<StressEvent>>
      _stressEventsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.stressEvents,
              aliasName: 'monitoring_sessions__id__stress_events__session_id');

  $$StressEventsTableProcessedTableManager get stressEventsRefs {
    final manager = $$StressEventsTableTableManager($_db, $_db.stressEvents)
        .filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stressEventsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MonitoringSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $MonitoringSessionsTable> {
  $$MonitoringSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgStressProb => $composableBuilder(
      column: $table.avgStressProb, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stressEventCount => $composableBuilder(
      column: $table.stressEventCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interventionCount => $composableBuilder(
      column: $table.interventionCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> stressEventsRefs(
      Expression<bool> Function($$StressEventsTableFilterComposer f) f) {
    final $$StressEventsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stressEvents,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StressEventsTableFilterComposer(
              $db: $db,
              $table: $db.stressEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MonitoringSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonitoringSessionsTable> {
  $$MonitoringSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endedAt => $composableBuilder(
      column: $table.endedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgStressProb => $composableBuilder(
      column: $table.avgStressProb,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stressEventCount => $composableBuilder(
      column: $table.stressEventCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interventionCount => $composableBuilder(
      column: $table.interventionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$MonitoringSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonitoringSessionsTable> {
  $$MonitoringSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<double> get avgStressProb => $composableBuilder(
      column: $table.avgStressProb, builder: (column) => column);

  GeneratedColumn<int> get stressEventCount => $composableBuilder(
      column: $table.stressEventCount, builder: (column) => column);

  GeneratedColumn<int> get interventionCount => $composableBuilder(
      column: $table.interventionCount, builder: (column) => column);

  GeneratedColumn<int> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> stressEventsRefs<T extends Object>(
      Expression<T> Function($$StressEventsTableAnnotationComposer a) f) {
    final $$StressEventsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stressEvents,
        getReferencedColumn: (t) => t.sessionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StressEventsTableAnnotationComposer(
              $db: $db,
              $table: $db.stressEvents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MonitoringSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonitoringSessionsTable,
    MonitoringSession,
    $$MonitoringSessionsTableFilterComposer,
    $$MonitoringSessionsTableOrderingComposer,
    $$MonitoringSessionsTableAnnotationComposer,
    $$MonitoringSessionsTableCreateCompanionBuilder,
    $$MonitoringSessionsTableUpdateCompanionBuilder,
    (MonitoringSession, $$MonitoringSessionsTableReferences),
    MonitoringSession,
    PrefetchHooks Function({bool stressEventsRefs})> {
  $$MonitoringSessionsTableTableManager(
      _$AppDatabase db, $MonitoringSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonitoringSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonitoringSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonitoringSessionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> startedAt = const Value.absent(),
            Value<int?> endedAt = const Value.absent(),
            Value<double?> avgStressProb = const Value.absent(),
            Value<int> stressEventCount = const Value.absent(),
            Value<int> interventionCount = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitoringSessionsCompanion(
            id: id,
            startedAt: startedAt,
            endedAt: endedAt,
            avgStressProb: avgStressProb,
            stressEventCount: stressEventCount,
            interventionCount: interventionCount,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int startedAt,
            Value<int?> endedAt = const Value.absent(),
            Value<double?> avgStressProb = const Value.absent(),
            Value<int> stressEventCount = const Value.absent(),
            Value<int> interventionCount = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonitoringSessionsCompanion.insert(
            id: id,
            startedAt: startedAt,
            endedAt: endedAt,
            avgStressProb: avgStressProb,
            stressEventCount: stressEventCount,
            interventionCount: interventionCount,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MonitoringSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({stressEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (stressEventsRefs) db.stressEvents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (stressEventsRefs)
                    await $_getPrefetchedData<MonitoringSession,
                            $MonitoringSessionsTable, StressEvent>(
                        currentTable: table,
                        referencedTable: $$MonitoringSessionsTableReferences
                            ._stressEventsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MonitoringSessionsTableReferences(db, table, p0)
                                .stressEventsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.sessionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MonitoringSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonitoringSessionsTable,
    MonitoringSession,
    $$MonitoringSessionsTableFilterComposer,
    $$MonitoringSessionsTableOrderingComposer,
    $$MonitoringSessionsTableAnnotationComposer,
    $$MonitoringSessionsTableCreateCompanionBuilder,
    $$MonitoringSessionsTableUpdateCompanionBuilder,
    (MonitoringSession, $$MonitoringSessionsTableReferences),
    MonitoringSession,
    PrefetchHooks Function({bool stressEventsRefs})>;
typedef $$StressEventsTableCreateCompanionBuilder = StressEventsCompanion
    Function({
  required String id,
  required String sessionId,
  required String eventType,
  required int occurredAt,
  Value<int?> stressClass,
  Value<double?> probability,
  Value<int?> syncedAt,
  Value<int> rowid,
});
typedef $$StressEventsTableUpdateCompanionBuilder = StressEventsCompanion
    Function({
  Value<String> id,
  Value<String> sessionId,
  Value<String> eventType,
  Value<int> occurredAt,
  Value<int?> stressClass,
  Value<double?> probability,
  Value<int?> syncedAt,
  Value<int> rowid,
});

final class $$StressEventsTableReferences
    extends BaseReferences<_$AppDatabase, $StressEventsTable, StressEvent> {
  $$StressEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MonitoringSessionsTable _sessionIdTable(_$AppDatabase db) =>
      db.monitoringSessions
          .createAlias('stress_events__session_id__monitoring_sessions__id');

  $$MonitoringSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager =
        $$MonitoringSessionsTableTableManager($_db, $_db.monitoringSessions)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StressEventsTableFilterComposer
    extends Composer<_$AppDatabase, $StressEventsTable> {
  $$StressEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stressClass => $composableBuilder(
      column: $table.stressClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get probability => $composableBuilder(
      column: $table.probability, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  $$MonitoringSessionsTableFilterComposer get sessionId {
    final $$MonitoringSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.monitoringSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonitoringSessionsTableFilterComposer(
              $db: $db,
              $table: $db.monitoringSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StressEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $StressEventsTable> {
  $$StressEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eventType => $composableBuilder(
      column: $table.eventType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stressClass => $composableBuilder(
      column: $table.stressClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get probability => $composableBuilder(
      column: $table.probability, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  $$MonitoringSessionsTableOrderingComposer get sessionId {
    final $$MonitoringSessionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sessionId,
        referencedTable: $db.monitoringSessions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonitoringSessionsTableOrderingComposer(
              $db: $db,
              $table: $db.monitoringSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StressEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StressEventsTable> {
  $$StressEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<int> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<int> get stressClass => $composableBuilder(
      column: $table.stressClass, builder: (column) => column);

  GeneratedColumn<double> get probability => $composableBuilder(
      column: $table.probability, builder: (column) => column);

  GeneratedColumn<int> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  $$MonitoringSessionsTableAnnotationComposer get sessionId {
    final $$MonitoringSessionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.sessionId,
            referencedTable: $db.monitoringSessions,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MonitoringSessionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.monitoringSessions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$StressEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StressEventsTable,
    StressEvent,
    $$StressEventsTableFilterComposer,
    $$StressEventsTableOrderingComposer,
    $$StressEventsTableAnnotationComposer,
    $$StressEventsTableCreateCompanionBuilder,
    $$StressEventsTableUpdateCompanionBuilder,
    (StressEvent, $$StressEventsTableReferences),
    StressEvent,
    PrefetchHooks Function({bool sessionId})> {
  $$StressEventsTableTableManager(_$AppDatabase db, $StressEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StressEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StressEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StressEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<String> eventType = const Value.absent(),
            Value<int> occurredAt = const Value.absent(),
            Value<int?> stressClass = const Value.absent(),
            Value<double?> probability = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StressEventsCompanion(
            id: id,
            sessionId: sessionId,
            eventType: eventType,
            occurredAt: occurredAt,
            stressClass: stressClass,
            probability: probability,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            required String eventType,
            required int occurredAt,
            Value<int?> stressClass = const Value.absent(),
            Value<double?> probability = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StressEventsCompanion.insert(
            id: id,
            sessionId: sessionId,
            eventType: eventType,
            occurredAt: occurredAt,
            stressClass: stressClass,
            probability: probability,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StressEventsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sessionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sessionId,
                    referencedTable:
                        $$StressEventsTableReferences._sessionIdTable(db),
                    referencedColumn:
                        $$StressEventsTableReferences._sessionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StressEventsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StressEventsTable,
    StressEvent,
    $$StressEventsTableFilterComposer,
    $$StressEventsTableOrderingComposer,
    $$StressEventsTableAnnotationComposer,
    $$StressEventsTableCreateCompanionBuilder,
    $$StressEventsTableUpdateCompanionBuilder,
    (StressEvent, $$StressEventsTableReferences),
    StressEvent,
    PrefetchHooks Function({bool sessionId})>;
typedef $$PreferenceWeightsTableCreateCompanionBuilder
    = PreferenceWeightsCompanion Function({
  required String intervention,
  Value<double> weight,
  required int updatedAt,
  Value<int?> syncedAt,
  Value<int> rowid,
});
typedef $$PreferenceWeightsTableUpdateCompanionBuilder
    = PreferenceWeightsCompanion Function({
  Value<String> intervention,
  Value<double> weight,
  Value<int> updatedAt,
  Value<int?> syncedAt,
  Value<int> rowid,
});

class $$PreferenceWeightsTableFilterComposer
    extends Composer<_$AppDatabase, $PreferenceWeightsTable> {
  $$PreferenceWeightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get intervention => $composableBuilder(
      column: $table.intervention, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$PreferenceWeightsTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferenceWeightsTable> {
  $$PreferenceWeightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get intervention => $composableBuilder(
      column: $table.intervention,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$PreferenceWeightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferenceWeightsTable> {
  $$PreferenceWeightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get intervention => $composableBuilder(
      column: $table.intervention, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PreferenceWeightsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PreferenceWeightsTable,
    PreferenceWeight,
    $$PreferenceWeightsTableFilterComposer,
    $$PreferenceWeightsTableOrderingComposer,
    $$PreferenceWeightsTableAnnotationComposer,
    $$PreferenceWeightsTableCreateCompanionBuilder,
    $$PreferenceWeightsTableUpdateCompanionBuilder,
    (
      PreferenceWeight,
      BaseReferences<_$AppDatabase, $PreferenceWeightsTable, PreferenceWeight>
    ),
    PreferenceWeight,
    PrefetchHooks Function()> {
  $$PreferenceWeightsTableTableManager(
      _$AppDatabase db, $PreferenceWeightsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferenceWeightsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferenceWeightsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferenceWeightsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> intervention = const Value.absent(),
            Value<double> weight = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PreferenceWeightsCompanion(
            intervention: intervention,
            weight: weight,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String intervention,
            Value<double> weight = const Value.absent(),
            required int updatedAt,
            Value<int?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PreferenceWeightsCompanion.insert(
            intervention: intervention,
            weight: weight,
            updatedAt: updatedAt,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PreferenceWeightsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PreferenceWeightsTable,
    PreferenceWeight,
    $$PreferenceWeightsTableFilterComposer,
    $$PreferenceWeightsTableOrderingComposer,
    $$PreferenceWeightsTableAnnotationComposer,
    $$PreferenceWeightsTableCreateCompanionBuilder,
    $$PreferenceWeightsTableUpdateCompanionBuilder,
    (
      PreferenceWeight,
      BaseReferences<_$AppDatabase, $PreferenceWeightsTable, PreferenceWeight>
    ),
    PreferenceWeight,
    PrefetchHooks Function()>;
typedef $$CalibrationStatsTableCreateCompanionBuilder
    = CalibrationStatsCompanion Function({
  Value<int> id,
  required int calibratedAt,
  required List<double> means,
  required List<double> stds,
  Value<int?> syncedAt,
});
typedef $$CalibrationStatsTableUpdateCompanionBuilder
    = CalibrationStatsCompanion Function({
  Value<int> id,
  Value<int> calibratedAt,
  Value<List<double>> means,
  Value<List<double>> stds,
  Value<int?> syncedAt,
});

class $$CalibrationStatsTableFilterComposer
    extends Composer<_$AppDatabase, $CalibrationStatsTable> {
  $$CalibrationStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calibratedAt => $composableBuilder(
      column: $table.calibratedAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<double>, List<double>, String>
      get means => $composableBuilder(
          column: $table.means,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<double>, List<double>, String> get stds =>
      $composableBuilder(
          column: $table.stds,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$CalibrationStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalibrationStatsTable> {
  $$CalibrationStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calibratedAt => $composableBuilder(
      column: $table.calibratedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get means => $composableBuilder(
      column: $table.means, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stds => $composableBuilder(
      column: $table.stds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$CalibrationStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalibrationStatsTable> {
  $$CalibrationStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get calibratedAt => $composableBuilder(
      column: $table.calibratedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<double>, String> get means =>
      $composableBuilder(column: $table.means, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<double>, String> get stds =>
      $composableBuilder(column: $table.stds, builder: (column) => column);

  GeneratedColumn<int> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CalibrationStatsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CalibrationStatsTable,
    CalibrationStat,
    $$CalibrationStatsTableFilterComposer,
    $$CalibrationStatsTableOrderingComposer,
    $$CalibrationStatsTableAnnotationComposer,
    $$CalibrationStatsTableCreateCompanionBuilder,
    $$CalibrationStatsTableUpdateCompanionBuilder,
    (
      CalibrationStat,
      BaseReferences<_$AppDatabase, $CalibrationStatsTable, CalibrationStat>
    ),
    CalibrationStat,
    PrefetchHooks Function()> {
  $$CalibrationStatsTableTableManager(
      _$AppDatabase db, $CalibrationStatsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalibrationStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalibrationStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalibrationStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> calibratedAt = const Value.absent(),
            Value<List<double>> means = const Value.absent(),
            Value<List<double>> stds = const Value.absent(),
            Value<int?> syncedAt = const Value.absent(),
          }) =>
              CalibrationStatsCompanion(
            id: id,
            calibratedAt: calibratedAt,
            means: means,
            stds: stds,
            syncedAt: syncedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int calibratedAt,
            required List<double> means,
            required List<double> stds,
            Value<int?> syncedAt = const Value.absent(),
          }) =>
              CalibrationStatsCompanion.insert(
            id: id,
            calibratedAt: calibratedAt,
            means: means,
            stds: stds,
            syncedAt: syncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CalibrationStatsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CalibrationStatsTable,
    CalibrationStat,
    $$CalibrationStatsTableFilterComposer,
    $$CalibrationStatsTableOrderingComposer,
    $$CalibrationStatsTableAnnotationComposer,
    $$CalibrationStatsTableCreateCompanionBuilder,
    $$CalibrationStatsTableUpdateCompanionBuilder,
    (
      CalibrationStat,
      BaseReferences<_$AppDatabase, $CalibrationStatsTable, CalibrationStat>
    ),
    CalibrationStat,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InterventionLogsTableTableManager get interventionLogs =>
      $$InterventionLogsTableTableManager(_db, _db.interventionLogs);
  $$MonitoringSessionsTableTableManager get monitoringSessions =>
      $$MonitoringSessionsTableTableManager(_db, _db.monitoringSessions);
  $$StressEventsTableTableManager get stressEvents =>
      $$StressEventsTableTableManager(_db, _db.stressEvents);
  $$PreferenceWeightsTableTableManager get preferenceWeights =>
      $$PreferenceWeightsTableTableManager(_db, _db.preferenceWeights);
  $$CalibrationStatsTableTableManager get calibrationStats =>
      $$CalibrationStatsTableTableManager(_db, _db.calibrationStats);
}
