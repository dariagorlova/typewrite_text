# typewrite_text

[![pub package](https://img.shields.io/pub/v/typewrite_text.svg?logo=flutter&color=blue&style=flat-square)](https://pub.dev/packages/typewrite_text)

A typewriter text animation wrapper with customizations. Supports iOS, Android, web, Windows, macOS, and Linux.

## Motivation

While creating a website for myself, I decided to embellish it with a small yet striking text animation to give it extra allure. This little detail not only added beauty to my site but also brought dynamism, making it stand out among others. While there **are** some packages that offer almost what I need, they **weren't quite sufficient** for my vision.

## Features

- Allows to set up different delays for forward and reverse animation.
- Allows to set up different delays before animation starts and after animation ends.
- Can be used just in "forward" mode.
- Any unicode symbol can be used as a "cursor" symbol
- Can be used with or without animated text cursor.
- Allows to set up text theme.
- Vibration while animating can be used for Android and iOS devices

## Usage

Basic animation. Just add text line(s) and specify text theme:

```dart
TypewriteText(
  linesOfText: ['Hello World', 'Hello Flutter', 'Hello Dart'],
  textStyle: TextStyle(color: Colors.red),
  cursorSymbol: '|',
),
```

One side animation without showing animated text cursor:

```dart
TypewriteText(
  linesOfText: ['Hello World', 'Hello Flutter', 'Hello Dart'],
  textStyle: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
  reverseAnimationDuration: Duration.zero,
  beforeAnimationDuration: Duration.zero,
)
```
more samples in "example" folder of the package

![](demo/package.gif)

## Documentation

| Property                 | Purpose                                                                                                                                                                         |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **linesOfText**          | List of strings to be shown.                                                                                                                                                    |
| **textStyle**            | TextStyle for this strings.                                                                                                                                                     |
| forwardAnimationDuration | The rate of a symbol appears.                                                                                                                                                   |
| reverseAnimationDuration | The rate of a symbol vanishes.                                                                                                                                                  |
| beforeAnimationDuration  | The interval before the symbols' initial appearance.                                                                                                                            |
| afterAnimationDuration   | The pause following the display of all symbols.                                                                                                                                 |
| cursorBlinkingDuration   | Interval of cursor blinking (cursorSymbol != null). If Duration.zero is used, cursor will always visible                                                                        |
| cursorSymbol             | Default value is **null**. This means, cursor will not be shown. Otherwise, use any unicode symbol, that will be used as a cursor symbol ( "..." , "●", "֍" or any other one)   |
| cursorColor              | Color of the animated text cursor.                                                                                                                                              |
| tryToVibrate             | enum value of vibration type. Default is "none"                                                                                                                                 |
| textAlign                | Alignment of the text in base widget. Important if output is a multiline                                                                                                        |
| callback                 | Callback when animation reaches beforeAnimationDuration. This means one element of linesOfText was shown and hidden and we reach a small gap before showing a next one element. |
| infiniteLoop             | Flag of the infinite animation. Default is "true"                                                                                                                               |
