// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calibration_stats_dao.dart';

// ignore_for_file: type=lint
mixin _$CalibrationStatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CalibrationStatsTable get calibrationStats =>
      attachedDatabase.calibrationStats;
  CalibrationStatsDaoManager get managers => CalibrationStatsDaoManager(this);
}

class CalibrationStatsDaoManager {
  final _$CalibrationStatsDaoMixin _db;
  CalibrationStatsDaoManager(this._db);
  $$CalibrationStatsTableTableManager get calibrationStats =>
      $$CalibrationStatsTableTableManager(
          _db.attachedDatabase, _db.calibrationStats);
}
