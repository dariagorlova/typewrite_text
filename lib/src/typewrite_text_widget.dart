import 'dart:async';

import 'package:flutter/material.dart';

class TypewriteText extends StatefulWidget {
  /// A typewriter text animation wrapper with customizations
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

  /// List of strings to be shown
  final List<String> linesOfText;

  /// TextStyle for this strings
  final TextStyle textStyle;

  /// The rate of a symbol appears
  final Duration forwardAnimationDuration;

  /// The rate of a symbol vanishes
  final Duration reverseAnimationDuration;

  /// The interval before the symbols' initial appearance
  final Duration beforeAnimationDuration;

  /// The pause following the display of all symbols
  final Duration afterAnimationDuration;

  /// Whether or not to display a cursor
  final bool needCursor;

  /// Color of the animated text cursor
  final Color? cursorColor;

  @override
  State<TypewriteText> createState() => _TypewriteTextState();
}

class _TypewriteTextState extends State<TypewriteText> {
  /// string index
  var _currentIndex = 0;

  /// char index for widget.linesOfText[_currentIndex]
  var _currentCharIndex = 0;

  /// reverse mode flag
  var _reverseMode = false;

  /// timer for cursor
  Timer? _timer;

  /// cursor visibility flag
  var _cursorVisible = false;

  /// Performs the typewriting animation.
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
    final curDuration = _reverseMode
        ? widget.reverseAnimationDuration
        : widget.forwardAnimationDuration;

    /// update the state only if we need it (oneside animation feature)
    if (mounted && curDuration != Duration.zero) {
      setState(() {});
    }
    Future.delayed(curDuration, () {
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
  Widget build(BuildContext context) {
    final text = widget.linesOfText[_currentIndex].length >= _currentCharIndex
        ? widget.linesOfText[_currentIndex].substring(0, _currentCharIndex)
        : '';
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
              color:
                  widget.cursorColor ?? widget.textStyle.color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
