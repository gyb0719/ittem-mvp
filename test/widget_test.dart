// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ittem_app/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: IttemApp(),
      ),
    );

    // Verify that the app loads properly
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('대여목록'), findsOneWidget);
    expect(find.text('채팅'), findsOneWidget);
    expect(find.text('프로필'), findsOneWidget);
  });
}
