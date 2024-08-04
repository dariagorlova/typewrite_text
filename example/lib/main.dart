import 'package:flutter/material.dart';
import 'package:typewrite_text/typewrite_text.dart';

void main() => runApp(const TextPackageApp());

const list1 = [
  'Hello World',
  'Hello Flutter',
  'Hello Dart',
];

const list2 = [
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
];

const listGPT = [
  'Easily animate your text',
  'with typewriter effect',
  "let's start",
  'with typewrite_text package',
];

class TextPackageApp extends StatelessWidget {
  const TextPackageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Package Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('typewrite_text demo'),
          backgroundColor: Colors.blue,
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// chatgpt app style with vibration
                Center(
                  child: TypewriteText(
                    linesOfText: listGPT,
                    textStyle: TextStyle(color: Colors.teal, fontSize: 24),
                    cursorSymbol: '●',
                    tryToVibrate: true,
                    forwardAnimationDuration: Duration(milliseconds: 50),
                    reverseAnimationDuration: Duration(milliseconds: 50),
                    cursorBlinkingDuration: Duration.zero,
                  ),
                ),
                SizedBox(height: 20),

                /// basic animation
                TypewriteText(
                  linesOfText: list1,
                  textStyle: TextStyle(color: Colors.red),
                  cursorSymbol: '|',
                ),
                SizedBox(height: 20),

                /// oneside animation (without reverse animation)
                TypewriteText(
                  linesOfText: list1,
                  textStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  reverseAnimationDuration: Duration.zero,
                  beforeAnimationDuration: Duration.zero,
                ),
                SizedBox(height: 20),

                /// multiline text animation
                TypewriteText(
                  linesOfText: list2,
                  textStyle: TextStyle(color: Colors.black),
                  forwardAnimationDuration: Duration(milliseconds: 50),
                  reverseAnimationDuration: Duration(milliseconds: 20),
                  cursorColor: Colors.red,
                  cursorSymbol: '|',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
