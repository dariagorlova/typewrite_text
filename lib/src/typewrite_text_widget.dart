import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum VibrationType { none, light, medium, heavy }

final Map<VibrationType, VoidCallback> vibrationMap = {
  VibrationType.none: () {},
  VibrationType.light: HapticFeedback.lightImpact,
  VibrationType.medium: HapticFeedback.mediumImpact,
  VibrationType.heavy: HapticFeedback.heavyImpact,
};

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
    this.tryToVibrate = VibrationType.none,
    this.textAlign,
    this.callback,
    this.infiniteLoop = true,
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

  /// Vibration feature. Can be none, light, medium or heavy.
  final VibrationType tryToVibrate;

  /// Alignment of the text in base widget. use if output is a multiline
  final TextAlign? textAlign;

  /// callback when animation reaches beforeAnimationDuration
  /// this means one element of linesOfText was shown and hidden.
  /// and we reach a small gap before showing a next one element.
  final VoidCallback? callback;

  /// if true, animation will be infinite. Default: true
  final bool infiniteLoop;

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

  /// pause flag. used to pause the timer when TypewriteText is not on current screen
  /// it's not enough to just cancel the timer in didChangeDependencies, cause
  /// it may still launch it's function. so we need to check the possibility of
  /// running _typeWrittingAnimation inside it.
  var _isPaused = false;

  /// Performs the typewriting animation.
  void _typeWrittingAnimation() {
    if (_isPaused) {
      return;
    }

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
        widget.callback?.call();
      }
    }

    if (mounted && curDuration != Duration.zero) {
      setState(() {
        /// screen update & vibration feature
        vibrationMap[widget.tryToVibrate]?.call();
      });
    }

    /// launch timer
    _animationTimer = Timer(curDuration, () {
      _typeWrittingAnimation();
    });

    if (!widget.infiniteLoop &&
        _currentIndex == widget.linesOfText.length - 1 &&
        _currentCharIndex == widget.linesOfText[_currentIndex].length) {
      _animationTimer?.cancel();
      _timer?.cancel();
    }
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

  /// lets stop timer if widget is not on current screen and relaunch it if it is
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isCurrentScreen = ModalRoute.of(context)?.isCurrent ?? false;
    if (isCurrentScreen) {
      if (_isPaused) {
        _isPaused = false;
        _typeWrittingAnimation();
      }
    } else {
      _isPaused = true;
      _animationTimer?.cancel();
      _timer?.cancel();
    }
  }

  @override

  /// Builds a [RichText] widget that displays the current line of text being typed.
  Widget build(BuildContext context) {
    final text = widget.linesOfText[_currentIndex].length >= _currentCharIndex
        ? widget.linesOfText[_currentIndex].substring(0, _currentCharIndex)
        : '';

    return RichText(
      textAlign: widget.textAlign ?? TextAlign.start,
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
