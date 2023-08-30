/*
  {
    "_id": {
      "$oid": "64bcc4d2557b67e9e20393dc"
    },
    "category": "Spice",
    "id": 20,
    "isVeg": true,
    "isVegan": true,
    "description": "Aromatic substances used to flavor food.",
    "culinaryUses": "Used in small quantities to add taste and aroma to dishes.",
    "safetyConsiderations": "Some spices may cause allergies or sensitivities in some individuals.",
    "types": [
      "Black Pepper",
      "Cumin",
      "Turmeric",
      "Cinnamon",
      "Paprika",
      "Cardamom"
    ]
  }
*/

import 'package:equatable/equatable.dart';

/// a class that represents a category.
/// along with the category [name], it also contains the list of [types] belonging to the category.
/// it also contains the [isVeg] and [isVegan] properties that tells if the category is vegetarian and vegan respectively.
/// it also contains the [description], [culinaryUses] and [safetyConsiderations] of the category.

class Category extends Equatable {
  const Category({
    this.id,
    this.name,
    this.types,
    this.isVeg,
    this.isVegan,
    this.description,
    this.culinaryUses,
    this.safetyConsiderations,
  });

  /// a unique id of the category.
  final String? id;

  /// name of the category.
  final String? name;

  /// list of types belonging to the category.
  final List<String>? types;

  /// isVeg is true if the category is vegetarian.

  final bool? isVeg;

  /// isVegan is true if the category is vegan.
  final bool? isVegan;

  /// description of the category.
  final String? description;

  /// culinaryUses of the category.
  final String? culinaryUses;

  /// safetyConsiderations of the category.
  final String? safetyConsiderations;

  /// fromJson that returns \[Category\] when a valid json is provided.
  static Category fromJson(Map<String, dynamic> json) => Category(
        id: json['_id']?['\$oid']?.toString(),
        name: json['name']?.toString(),
        types: List<String>.from(json['types']?.map((e) => '$e')),
        isVeg: json['isVeg']?.toString() == 'true',
        isVegan: json['isVegan']?.toString() == 'true',
        description: json['description']?.toString(),
        culinaryUses: json['culinaryUses']?.toString(),
        safetyConsiderations: json['safetyConsiderations']?.toString(),
      );

  /// toJson that returns \[Map<String, dynamic>\] when a valid \[Category\] is provided.
  Map<String, dynamic> toJson() => {
        '_id': {'\$oid': id},
        'name': name,
        'types': types,
        'isVeg': isVeg,
        'isVegan': isVegan,
        'description': description,
        'culinaryUses': culinaryUses,
        'safetyConsiderations': safetyConsiderations,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        types,
        isVeg,
        isVegan,
        description,
        culinaryUses,
        safetyConsiderations
      ];
}
