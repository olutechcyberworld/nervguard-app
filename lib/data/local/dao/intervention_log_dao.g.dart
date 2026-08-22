// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention_log_dao.dart';

// ignore_for_file: type=lint
mixin _$InterventionLogDaoMixin on DatabaseAccessor<AppDatabase> {
  $InterventionLogsTable get interventionLogs =>
      attachedDatabase.interventionLogs;
  InterventionLogDaoManager get managers => InterventionLogDaoManager(this);
}

class InterventionLogDaoManager {
  final _$InterventionLogDaoMixin _db;
  InterventionLogDaoManager(this._db);
  $$InterventionLogsTableTableManager get interventionLogs =>
      $$InterventionLogsTableTableManager(
          _db.attachedDatabase, _db.interventionLogs);
}
