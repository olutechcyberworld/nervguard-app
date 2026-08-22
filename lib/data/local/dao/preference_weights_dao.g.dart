// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_weights_dao.dart';

// ignore_for_file: type=lint
mixin _$PreferenceWeightsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PreferenceWeightsTable get preferenceWeights =>
      attachedDatabase.preferenceWeights;
  PreferenceWeightsDaoManager get managers => PreferenceWeightsDaoManager(this);
}

class PreferenceWeightsDaoManager {
  final _$PreferenceWeightsDaoMixin _db;
  PreferenceWeightsDaoManager(this._db);
  $$PreferenceWeightsTableTableManager get preferenceWeights =>
      $$PreferenceWeightsTableTableManager(
          _db.attachedDatabase, _db.preferenceWeights);
}
