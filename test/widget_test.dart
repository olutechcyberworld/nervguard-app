import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nervguard/app.dart';

void main() {
  testWidgets('NervGuardApp builds without throwing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NervGuardApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
