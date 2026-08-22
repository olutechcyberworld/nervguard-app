import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/local/database/app_database.dart';
import '../../data/preferences/app_preferences.dart';
import '../../data/remote/supabase_sync_client.dart';
import '../../domain/services/sync_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final appPreferencesProvider = FutureProvider<AppPreferences>((ref) {
  return AppPreferences.create();
});

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final supabaseSyncClientProvider = Provider<SupabaseSyncClient>((ref) {
  return SupabaseSyncClient(ref.watch(supabaseClientProvider));
});

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final service = SyncService(
    database: ref.watch(appDatabaseProvider),
    syncClient: ref.watch(supabaseSyncClientProvider),
    currentUserId: () => supabase.auth.currentUser?.id,
  );
  service.start();
  ref.onDispose(service.dispose);
  return service;
});
