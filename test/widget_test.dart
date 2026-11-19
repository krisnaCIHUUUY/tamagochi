import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tamagochi/app.dart';

void main() {
  testWidgets('app boots', (tester) async {
    await tester.pumpWidget(const TamaApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
