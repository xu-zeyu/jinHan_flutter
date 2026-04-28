// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:jinhan_flutter/app.dart';

void main() {
  testWidgets('shows home content', (WidgetTester tester) async {
    await tester.pumpWidget(const JinHanApp());

    expect(find.text('金晗优宠'), findsAtLeastNWidgets(1));
    expect(find.text('给毛孩子更安心的照护体验'), findsOneWidget);
  });
}
