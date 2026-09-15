import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qse_dashboard/main.dart';

void main() {
  testWidgets('App launches and shows the dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const QseDashboardApp());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
