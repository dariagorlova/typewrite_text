import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typewrite_text/typewrite_text.dart';

void main() {
  group('TypewriteText test', () {
    final data = ['Hello'];
    final delays = {
      'H_up': const Duration(milliseconds: 249), //forwardAnimation - 1
      'He_up': const Duration(milliseconds: 250), //forwardAnimation
      'Hel_up': const Duration(milliseconds: 250), //forwardAnimation
      'Hell_up': const Duration(milliseconds: 250), //forwardAnimation
      'Hello_up': const Duration(milliseconds: 250), //forwardAnimation
      'Hello_stay': const Duration(milliseconds: 1000), // afterAnimation
      'Hell_down': const Duration(milliseconds: 100), //reverseAnimation
      'Hel_down': const Duration(milliseconds: 100), //reverseAnimation
      'He_down': const Duration(milliseconds: 100), //reverseAnimation
      'H_down': const Duration(milliseconds: 100), //reverseAnimation
      '_down': const Duration(milliseconds: 1500), // beforeAnimation
      'H_up2': const Duration(milliseconds: 250), //forwardAnimation
    };

    testWidgets('TypewriteText widget test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TypewriteText(
                linesOfText: data,
                textStyle: const TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
          ),
        ),
      );

      //
      for (final e in delays.entries) {
        final foundText = e.key.split('_').first;
        await tester.pump(e.value);
        expect(find.text(foundText, findRichText: true), findsOneWidget);
      }
    });
  });
}
