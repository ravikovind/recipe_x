import 'package:equatable/equatable.dart';

/// a class that represents an ingredient.
/// along with the ingredient [name], it also contains the list of [synonyms], [compounds], [type], [category], [isVeg] and [isVegan].
///
/// [synonyms] are the [List] of [String] synonyms of the ingredient.
///
/// [compounds] are the [List] of [String] compounds of the ingredient.
///
/// [type] is the [String] type of the ingredient. type can specify the ingredient single or compound.
///
/// [category] is the category id of the ingredient. category id can be used to get the [Category] details.
///
/// [isVeg] is true if the ingredient is vegetarian.
///
/// [isVegan] is true if the ingredient is vegan.
///
/// [id] is the unique id of the ingredient.

class Ingredient extends Equatable {
  const Ingredient({
    this.id,
    this.name,
    this.synonyms,
    this.compounds,
    this.type,
    this.category,
    this.isVeg,
    this.isVegan,
  });

  /// a unique id of the ingredient.
  final String? id;

  /// name of the ingredient.
  final String? name;

  /// list of synonyms of the ingredient.
  final List<String>? synonyms;

  /// list of compounds of the ingredient.
  final List<String>? compounds;

  /// type of the ingredient.
  final String? type;

  /// category id of the ingredient.
  final String? category;

  /// isVeg is true if the ingredient is vegetarian.
  final bool? isVeg;

  /// isVegan is true if the ingredient is vegan.
  final bool? isVegan;

  /// factory constructor to create an Ingredient instance from a json of [Map] of [String] keys and [dynamic] values.
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['_id']?['\$oid']?.toString(),
      name: json['name']?.toString(),
      synonyms: json['synonyms']?.map<String>((e) => e.toString()).toList(),
      compounds: json['compounds']?.map<String>((e) => e.toString()).toList(),
      type: json['type']?.toString(),
      category: json['category']?['\$oid']?.toString(),
      isVeg: json['isVeg']?.toString() == 'true',
      isVegan: json['isVegan']?.toString() == 'true',
    );
  }

  /// a method that converts an Ingredient instance into a json of [Map] of [String] keys and [dynamic] values.
  Map<String, dynamic> toJson() {
    return {
      '_id': {'\$oid': id},
      'name': name,
      'synonyms': synonyms,
      'compounds': compounds,
      'type': type,
      'category': {'\$oid': category},
      'isVeg': isVeg,
      'isVegan': isVegan,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        synonyms,
        compounds,
        type,
        category,
        isVeg,
        isVegan,
      ];
}
