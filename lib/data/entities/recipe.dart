import 'package:equatable/equatable.dart';

/// a class that represents a recipe.
///
/// along with the recipe [name], it also contains the [description], [source] and [region] of the recipe.
///
/// the list of [ingredients] of the recipe. it is a list of [Ingredient] ids.
///
/// the [region] is the id of the [Region] to which the recipe belongs.
class Recipe extends Equatable {
  const Recipe({
    this.id,
    this.name,
    this.description,
    this.source,
    this.region,
    this.ingredients,
  });

  /// a unique id of the recipe.
  final String? id;

  /// name of the recipe.
  final String? name;

  /// description of the recipe.
  final String? description;

  /// source of the recipe.
  final String? source;

  /// region id of the recipe.
  final String? region;

  /// list of ingredients of the recipe.
  final List<String>? ingredients;

  /// factory constructor to create a Recipe instance from a json of [Map] of [String] keys and [dynamic] values.
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
      id: json['_id']?['\$oid']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      source: json['source']?.toString(),
      region: json['region']?['\$oid']?.toString(),
      ingredients: json['ingredients']
          ?.map<String>((e) => e['\$oid'].toString())
          .toList(),
    );

  /// a method that converts a Recipe instance into a json of [Map] of [String] keys and [dynamic] values.
  Map<String, dynamic> toJson() => {
      '_id': {'\$oid': id},
      'name': name,
      'description': description,
      'source': source,
      'region': {'\$oid': region},
      'ingredients': ingredients?.map((e) => {'\$oid': e}).toList(),
    };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        source,
        region,
        ingredients,
      ];
}
