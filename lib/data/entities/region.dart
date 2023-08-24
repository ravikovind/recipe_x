/*
{
    "_id": {
      "$oid": "64bcc186557b67e9e20393ab"
    },
    "name": "Africa",
    "id": 1,
    "countries": [
      "Algeria",
      "Egypt",
      "Nigeria",
      "South Africa",
      "Kenya",
      "Ethiopia",
      "Ghana",
      "Morocco",
      "Tunisia",
      "Tanzania"
    ]
  }
*/

import 'package:equatable/equatable.dart';

/// a class that represents a region.
/// along with the region [name], it also contains the list of [countries] belonging to the region.
class Region extends Equatable {
  const Region({
    this.id,
    this.name,
    this.countries,
  });

  /// a unique id of the region.
  final String? id;

  /// name of the region.
  final String? name;

  /// list of countries belonging to the region.
  final List<String>? countries;

  /// factory constructor to create a Region instance from a json of [Map] of [String] keys and [dynamic] values.
  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['_id']?['\$oid']?.toString(),
      name: json['name']?.toString(),
      countries: json['countries']?.map<String>((e) => e.toString()).toList(),
    );
  }

  /// a method that converts a Region instance into a json of [Map] of [String] keys and [dynamic] values.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'countries': countries,
    };
  }

  @override
  List<Object?> get props => [id, name, countries];
}
