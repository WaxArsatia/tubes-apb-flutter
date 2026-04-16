import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_apb_flutter/app/app.dart';

void main() {
  testWidgets('Landing screen loads', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text('Take Control of Your Money'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('Navigate to login from landing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(OutlinedButton, 'Log In'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
