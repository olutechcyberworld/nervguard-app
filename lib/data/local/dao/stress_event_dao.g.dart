// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stress_event_dao.dart';

// ignore_for_file: type=lint
mixin _$StressEventDaoMixin on DatabaseAccessor<AppDatabase> {
  $MonitoringSessionsTable get monitoringSessions =>
      attachedDatabase.monitoringSessions;
  $StressEventsTable get stressEvents => attachedDatabase.stressEvents;
  StressEventDaoManager get managers => StressEventDaoManager(this);
}

class StressEventDaoManager {
  final _$StressEventDaoMixin _db;
  StressEventDaoManager(this._db);
  $$MonitoringSessionsTableTableManager get monitoringSessions =>
      $$MonitoringSessionsTableTableManager(
          _db.attachedDatabase, _db.monitoringSessions);
  $$StressEventsTableTableManager get stressEvents =>
      $$StressEventsTableTableManager(_db.attachedDatabase, _db.stressEvents);
}
