import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// [OfString] is a [extension] on [String].
extension OfString on String {
  /// [isEmail] checks if the string is a valid email address.
  /// It returns true if the string is a valid email address.
  /// It returns false if the string is not a valid email address.

  bool get isEmail => RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
      ).hasMatch(this);

  /// [isPhoneNumber] checks if the string is a valid mobile number.
  /// It returns true if the string is a valid mobile number.
  /// It returns false if the string is not a valid mobile number.
  bool get isPhoneNumber => RegExp(
        r'^[0-9]{10}$',
      ).hasMatch(this);

  /// [isStrongPassword] checks if the string is a valid password.
  /// It returns true if the string is a valid password.
  /// It returns false if the string is not a valid password.
  bool get isStrongPassword {
    return RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#%()\$&*~]).{8,}$',
    ).hasMatch(this);
  }

  /// [capitalize] capitalizes the first letter of the string.
  /// It returns the capitalized string.
  /// It returns the original string if the string is empty.
  /// It returns the original string if the string is null.
  /// It returns the original string if the string is not a string.
  String get capitalize {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeAll {
    if (isEmpty) {
      return this;
    }

    return toLowerCase()
        .split(' ')
        .map(
          (word) => word.capitalize,
        )
        .join(' ');
  }
}

/// [OfDateTime] is a [extension] on [DateTime].
extension OfDateTime on DateTime {
  /// [toFormatedDate] formats the date to the given [format].
  /// [format] is the format of the date.
  /// It returns the formatted date.
  /// It returns the empty string if the date is null.
  String toFormatedDate({String format = 'dd/MM/yyyy'}) =>
      DateFormat(format).format(toLocal());
}

/// [OfColor] is list of [extension's] methods for [Color] class.
extension OfColor on Color {
  /// This is used to convert [Color] to [MaterialColor] for [ThemeData].
  MaterialColor get materialColor {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = red, g = green, b = blue;
    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(value, swatch);
  }
}

extension OfInt on int {
  String get toTimeString {
    final hour = this ~/ 3600;
    if (hour > 0) {
      final minuts = (this % 3600) ~/ 60;
      final seconds = (this % 3600) % 60;
      return '${hour.toString().padLeft(2, '0')} h : ${minuts.toString().padLeft(2, '0')} min : ${seconds.toString().padLeft(2, '0')} sec';
    } else {
      final minuts = this ~/ 60;
      final seconds = this % 60;
      return '${minuts.toString().padLeft(2, '0')} min : ${seconds.toString().padLeft(2, '0')} sec';
    }
  }
}
