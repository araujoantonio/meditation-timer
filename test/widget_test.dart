import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_timer/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MeditationTimerApp());
    expect(find.text('Meditation Timer'), findsOneWidget);
  });
}
