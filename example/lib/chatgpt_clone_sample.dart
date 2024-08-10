import 'dart:math';

import 'package:flutter/material.dart';
import 'package:typewrite_text/typewrite_text.dart';

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  final listGPT = [
    'Easily animate your text with typewriter effect',
    "let's start",
    'with typewrite_text package',
  ];

  final background = [
    Colors.yellow,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.white
  ];

  final textColors = [
    Colors.black,
    Colors.white,
    Colors.yellow,
    Colors.red,
    Colors.black,
    Colors.blue,
  ];

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final vibrationType =
        VibrationType.values[Random().nextInt(VibrationType.values.length)];
    debugPrint(vibrationType.name);
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: background[_currentIndex],
        child: Center(
          child: TypewriteText(
            linesOfText: listGPT,
            textStyle:
                TextStyle(color: textColors[_currentIndex], fontSize: 24),
            cursorSymbol: '●',
            tryToVibrate: vibrationType,
            forwardAnimationDuration: const Duration(milliseconds: 50),
            reverseAnimationDuration: const Duration(milliseconds: 50),
            beforeAnimationDuration: const Duration(milliseconds: 200),
            cursorBlinkingDuration: Duration.zero,
            textAlign: TextAlign.center,
            //infiniteLoop: false,
            callback: () {
              setState(() {
                _currentIndex = (_currentIndex + 1) % background.length;
              });
            },
          ),
        ));
  }
}
