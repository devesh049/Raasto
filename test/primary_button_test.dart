import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raasto/shared/widgets/primary_button.dart';

void main() {
  testWidgets('renders its label and fires onPressed', (WidgetTester tester) async {
    int taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Go', onPressed: () => taps++),
        ),
      ),
    );

    expect(find.text('Go'), findsOneWidget);
    await tester.tap(find.text('Go'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('shows a spinner while loading', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Save', isLoading: true, onPressed: () {}),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Save'), findsNothing);
  });

  testWidgets('a null onPressed does not throw when tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PrimaryButton(label: 'Disabled')),
      ),
    );

    await tester.tap(find.text('Disabled'), warnIfMissed: false);
    await tester.pump();
    expect(find.text('Disabled'), findsOneWidget);
  });
}
