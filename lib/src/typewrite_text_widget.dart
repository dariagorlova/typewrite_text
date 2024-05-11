import 'dart:async';

import 'package:flutter/material.dart';

class TypewriteText extends StatefulWidget {
  const TypewriteText({
    required this.linesOfText,
    required this.textStyle,
    this.forwardAnimationDuration = const Duration(milliseconds: 250),
    this.reverseAnimationDuration = const Duration(milliseconds: 100),
    this.beforeAnimationDuration = const Duration(milliseconds: 1500),
    this.afterAnimationDuration = const Duration(milliseconds: 1000),
    this.needCursor = true,
    this.cursorColor,
    super.key,
  });

  final List<String> linesOfText;
  final TextStyle textStyle;
  final Duration forwardAnimationDuration;
  final Duration reverseAnimationDuration;
  final Duration beforeAnimationDuration;
  final Duration afterAnimationDuration;
  final bool needCursor;
  final Color? cursorColor;

  @override
  State<TypewriteText> createState() => _TypewriteTextState();
}

class _TypewriteTextState extends State<TypewriteText> {
  var _currentIndex = 0;
  var _currentCharIndex = 0;
  var _reverseMode = false;
  Timer? _timer;
  var _cursorVisible = false;

  /// Performs the typewriting animation.
  ///
  /// This function is responsible for animating the typing effect of the text.
  /// It continuously updates the index of the current character being typed and
  /// handles the logic for reversing the animation.
  ///
  /// The animation starts in the forward mode and progresses until all the characters
  /// of the current line are typed. Once all the characters are typed, the animation
  /// transitions to the reverse mode. In the reverse mode, the animation goes back
  /// to the previous line and types the characters in reverse order.
  ///
  /// This function is called recursively using a delayed Future to create the
  /// illusion of continuous typing.
  ///
  /// This function does not take any parameters.
  ///
  /// This function does not return any value.
  void _typeWrittingAnimation() async {
    if (_reverseMode) {
      if (_currentCharIndex > 0) {
        _currentCharIndex--;
      } else {
        _reverseMode = false;
        _currentIndex = (_currentIndex + 1) % widget.linesOfText.length;
        _currentCharIndex = 0;
        await Future.delayed(widget.beforeAnimationDuration, () {});
      }
    } else {
      if (_currentCharIndex < widget.linesOfText[_currentIndex].length) {
        _currentCharIndex++;
      } else {
        _reverseMode = true;
        await Future.delayed(widget.afterAnimationDuration, () {});
      }
    }
    if (mounted) {
      setState(() {});
    }
    Future.delayed(_reverseMode ? widget.reverseAnimationDuration : widget.forwardAnimationDuration, () {
      _typeWrittingAnimation();
    });
  }

  @override
  // Initializes the state of the widget.
  void initState() {
    super.initState();
    if (widget.needCursor) {
      _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
        setState(() {
          _cursorVisible = !_cursorVisible;
        });
      });
    }
    _typeWrittingAnimation();
  }

  @override
  // Disposes of the resources used by the state.
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override

  /// Builds a [RichText] widget that displays the current line of text being typed.
  ///
  /// The text being displayed is determined by the current index of the line and the current index of the character.
  /// If the current index of the character is greater than or equal to the length of the current line, an empty string is displayed.
  ///
  /// The text is displayed with the provided [TextStyle] and includes a cursor that blinks on and off.
  /// The cursor color is determined by the [cursorColor] property of the widget, or the color of the text style if not provided.
  ///
  /// Returns a [RichText] widget.
  Widget build(BuildContext context) {
    final text =
        widget.linesOfText[_currentIndex].length >= _currentCharIndex ? widget.linesOfText[_currentIndex].substring(0, _currentCharIndex) : '';
    return RichText(
      text: TextSpan(
        text: text,
        style: widget.textStyle,
        children: <TextSpan>[
          TextSpan(
            text: _cursorVisible ? '|' : ' ',
            style: widget.textStyle.copyWith(
              fontSize: widget.textStyle.fontSize ?? 14,
              fontWeight: FontWeight.normal,
              color: widget.cursorColor ?? widget.textStyle.color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
