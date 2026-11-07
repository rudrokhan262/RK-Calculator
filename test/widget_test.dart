import 'package:flutter_test/flutter_test.dart';
import 'package:rk_calculator/main.dart';

void main() {
  testWidgets('RK Calculator instant startup test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RKCalculatorApp());

    // Verify that RK Calculator title is present immediately
    expect(find.text('RK Calculator'), findsOneWidget);
    expect(find.text('0'), findsWidgets);
  });
}
