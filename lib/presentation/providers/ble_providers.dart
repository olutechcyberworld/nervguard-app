import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/ble_message.dart';
import '../../domain/services/ble_service.dart';

/// Must be overridden at the ProviderScope root (or in tests) with a
/// concrete BleService implementation. FakeBleService through Sprint 4;
/// the real flutter_blue_plus-backed service from Sprint 5 onward. There
/// is intentionally no default implementation here, since constructing
/// one would require deciding fake-vs-real at this layer, which belongs
/// to app composition, not to provider definition.
final bleServiceProvider = Provider<BleService>((ref) {
  throw UnimplementedError(
    'bleServiceProvider must be overridden with a BleService implementation.',
  );
});

final bleEventProvider = StreamProvider<BleMessage>((ref) {
  return ref.watch(bleServiceProvider).events;
});

final bleConnectionProvider = StreamProvider<bool>((ref) {
  return ref.watch(bleServiceProvider).connectionState;
});
