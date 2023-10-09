/// [OfString] is a [extension] on [String].
extension OfString on String {
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
