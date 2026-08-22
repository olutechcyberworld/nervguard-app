import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

const _supabaseSchema = 'nervguard';

/// Thin wrapper around the Supabase REST calls SyncService needs, one
/// method per table. Isolating these calls behind this interface is
/// what makes SyncService unit-testable without mocking Supabase's
/// fluent schema().from().upsert() builder chain directly: tests mock
/// SupabaseSyncClient itself instead.
class SupabaseSyncClient {
  SupabaseSyncClient(this._client);

  final SupabaseClient _client;

  Future<void> upsertMonitoringSessions(List<Map<String, dynamic>> rows) {
    return _client
        .schema(_supabaseSchema)
        .from('monitoring_sessions')
        .upsert(rows);
  }

  Future<void> upsertInterventionLogs(List<Map<String, dynamic>> rows) {
    return _client
        .schema(_supabaseSchema)
        .from('intervention_logs')
        .upsert(rows);
  }

  Future<void> upsertPreferenceWeights(List<Map<String, dynamic>> rows) {
    return _client
        .schema(_supabaseSchema)
        .from('preference_weights')
        .upsert(rows, onConflict: 'user_id,intervention');
  }

  Future<void> upsertCalibrationStats(Map<String, dynamic> row) {
    return _client
        .schema(_supabaseSchema)
        .from('calibration_stats')
        .upsert(row, onConflict: 'user_id');
  }

  Future<void> upsertStressEvents(List<Map<String, dynamic>> rows) {
    return _client.schema(_supabaseSchema).from('stress_events').upsert(rows);
  }
}
