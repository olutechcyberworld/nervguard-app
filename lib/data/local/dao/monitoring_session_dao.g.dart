// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitoring_session_dao.dart';

// ignore_for_file: type=lint
mixin _$MonitoringSessionDaoMixin on DatabaseAccessor<AppDatabase> {
  $MonitoringSessionsTable get monitoringSessions =>
      attachedDatabase.monitoringSessions;
  MonitoringSessionDaoManager get managers => MonitoringSessionDaoManager(this);
}

class MonitoringSessionDaoManager {
  final _$MonitoringSessionDaoMixin _db;
  MonitoringSessionDaoManager(this._db);
  $$MonitoringSessionsTableTableManager get monitoringSessions =>
      $$MonitoringSessionsTableTableManager(
          _db.attachedDatabase, _db.monitoringSessions);
}
