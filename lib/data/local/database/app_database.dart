import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../dao/calibration_stats_dao.dart';
import '../dao/intervention_log_dao.dart';
import '../dao/monitoring_session_dao.dart';
import '../dao/preference_weights_dao.dart';
import '../dao/stress_event_dao.dart';

part 'app_database.g.dart';

/// Serialises List double to a JSON string column and back.
/// Used for calibration_stats.means and calibration_stats.stds,
/// avoiding 26 individual float columns per the locked architecture decision.
class DoubleListConverter extends TypeConverter<List<double>, String> {
  const DoubleListConverter();

  @override
  List<double> fromSql(String fromDb) {
    final decoded = jsonDecode(fromDb) as List<dynamic>;
    return decoded.map((e) => (e as num).toDouble()).toList(growable: false);
  }

  @override
  String toSql(List<double> value) => jsonEncode(value);
}

@DataClassName('InterventionLog')
class InterventionLogs extends Table {
  TextColumn get id => text()(); // client-generated UUID
  TextColumn get intervention => text()();
  TextColumn get tier => text()(); // 'mild' | 'intensive'
  IntColumn get triggeredAt => integer()(); // Unix milliseconds
  TextColumn get status => text().withDefault(
      const Constant('triggered'))(); // 'triggered' | 'helped' | 'skipped'
  IntColumn get acknowledgedAt => integer().nullable()();
  IntColumn get syncedAt =>
      integer().nullable()(); // NULL until pushed to Supabase

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MonitoringSession')
class MonitoringSessions extends Table {
  TextColumn get id => text()();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt =>
      integer().nullable()(); // NULL while session is active
  RealColumn get avgStressProb => real().nullable()();
  IntColumn get stressEventCount => integer().withDefault(const Constant(0))();
  IntColumn get interventionCount => integer().withDefault(const Constant(0))();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StressEvent')
class StressEvents extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(MonitoringSessions, #id)();
  TextColumn get eventType => text()(); // 'onset' | 'resolution'
  IntColumn get occurredAt => integer()();
  IntColumn get stressClass => integer().nullable()();
  RealColumn get probability => real().nullable()();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PreferenceWeight')
class PreferenceWeights extends Table {
  TextColumn get intervention => text()();
  RealColumn get weight => real().withDefault(const Constant(1.0))();
  IntColumn get updatedAt => integer()();
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {intervention};
}

@DataClassName('CalibrationStat')
class CalibrationStats extends Table {
  IntColumn get id =>
      integer().withDefault(const Constant(1))(); // always row 1
  IntColumn get calibratedAt => integer()();
  TextColumn get means =>
      text().map(const DoubleListConverter())(); // JSON array, 13 float64
  TextColumn get stds =>
      text().map(const DoubleListConverter())(); // JSON array, 13 float64
  IntColumn get syncedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    InterventionLogs,
    MonitoringSessions,
    StressEvents,
    PreferenceWeights,
    CalibrationStats,
  ],
  daos: [
    InterventionLogDao,
    MonitoringSessionDao,
    StressEventDao,
    PreferenceWeightsDao,
    CalibrationStatsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Used by both the main isolate and the background isolate, each opening
  /// its own AppDatabase instance against the same underlying file,
  /// per the Phase 3.6 database configuration.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nervguard.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA journal_mode = WAL');
        rawDb.execute('PRAGMA busy_timeout = 2000');
        rawDb.execute('PRAGMA foreign_keys = ON');
      },
    );
  });
}
