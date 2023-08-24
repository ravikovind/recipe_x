/*
    {
        "name": "Ascension Island",
        "code": "AC",
        "emoji": "🇦🇨",
        "unicode": "U+1F1E6 U+1F1E8"
    }
*/

import 'package:equatable/equatable.dart';

/// a class that represents a country.
/// along with the country [name], it also contains the country [code], [emoji] and [unicode].

class Country extends Equatable {
  const Country({
    this.name,
    this.code,
    this.emoji,
    this.unicode,
    this.image,
  });

  /// name of the country.
  final String? name;

  /// code of the country.
  final String? code;

  /// emoji of the country.
  final String? emoji;

  /// unicode of the country.
  final String? unicode;

  /// image of the country. it's svg url.
  final String? image;

  /// factory constructor to create a Country instance from a json of [Map] of [String] keys and [dynamic] values.
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']?.toString(),
      code: json['code']?.toString(),
      emoji: json['emoji']?.toString(),
      unicode: json['unicode']?.toString(),
      image: json['image']?.toString(),
    );
  }

  /// a method that converts a Country instance into a json of [Map] of [String] keys and [dynamic] values.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'emoji': emoji,
      'unicode': unicode,
      'image': image,
    };
  }

  @override
  List<Object?> get props => [name, code, emoji, unicode, image];
}