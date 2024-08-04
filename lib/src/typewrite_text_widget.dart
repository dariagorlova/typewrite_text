import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypewriteText extends StatefulWidget {
  /// A typewriter text animation wrapper with customizations
  const TypewriteText({
    required this.linesOfText,
    required this.textStyle,
    this.forwardAnimationDuration = const Duration(milliseconds: 250),
    this.reverseAnimationDuration = const Duration(milliseconds: 100),
    this.beforeAnimationDuration = const Duration(milliseconds: 1500),
    this.afterAnimationDuration = const Duration(milliseconds: 1000),
    this.cursorBlinkingDuration = const Duration(milliseconds: 500),
    this.cursorSymbol,
    this.cursorColor,
    this.tryToVibrate = false,
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

  /// Cursor blinking duration. Always shown = Duration.zero
  final Duration cursorBlinkingDuration;

  /// The interval before the symbols' initial appearance
  final Duration beforeAnimationDuration;

  /// The pause following the display of all symbols
  final Duration afterAnimationDuration;

  /// Any unicode symbol to be shown as a cursor
  final String? cursorSymbol;

  /// Color of the animated text cursor
  final Color? cursorColor;

  /// If you need a vibration while animating, set `true`. Default is `false`.
  final bool tryToVibrate;

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

  /// timer for animation
  Timer? _animationTimer;

  /// cursor visibility flag
  var _cursorVisible = false;

  /// Performs the typewriting animation.
  void _typeWrittingAnimation() {
    if (_reverseMode) {
      if (_currentCharIndex > 0) {
        _currentCharIndex--;
      } else {
        _reverseMode = false;
        _currentIndex = (_currentIndex + 1) % widget.linesOfText.length;
        _currentCharIndex = 0;
      }
    } else {
      if (_currentCharIndex < widget.linesOfText[_currentIndex].length) {
        _currentCharIndex++;
      } else {
        _reverseMode = true;
      }
    }

    /// here we need to know delay for next _typeWrittingAnimation launch
    /// default value is "forward"
    var curDuration = widget.forwardAnimationDuration;

    /// but it could be...
    if (_reverseMode) {
      /// ..."afterAnimation"
      if (_currentCharIndex == widget.linesOfText[_currentIndex].length) {
        curDuration = widget.afterAnimationDuration;
      } else {
        /// ... or "reverse"
        curDuration = widget.reverseAnimationDuration;
      }
    } else {
      /// ... or "beforeAnimation"
      if (_currentCharIndex == 0) {
        curDuration = widget.beforeAnimationDuration;
      }
    }

    if (mounted && curDuration != Duration.zero) {
      setState(() {
        /// if you need a small vibration and OS can do it...
        if (widget.tryToVibrate) {
          HapticFeedback.lightImpact();
        }
      });
    }

    _animationTimer = Timer(curDuration, () {
      _typeWrittingAnimation();
    });
  }

  @override

  /// Initializes the state of the widget.
  void initState() {
    super.initState();
    if (widget.cursorSymbol != null) {
      if (widget.cursorBlinkingDuration != Duration.zero) {
        _timer = Timer.periodic(widget.cursorBlinkingDuration, (_) {
          setState(() {
            _cursorVisible = !_cursorVisible;
          });
        });
      } else {
        _cursorVisible = true;
      }
    }
    _typeWrittingAnimation();
  }

  @override

  /// Disposes of the resources used by the state.
  void dispose() {
    _timer?.cancel();
    _animationTimer?.cancel();
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
            text: _cursorVisible && widget.cursorSymbol != null
                ? widget.cursorSymbol
                : '',
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
