import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart' show rootBundle;
import 'package:recipe_x/data/entities/category.dart';
import 'package:recipe_x/data/entities/country.dart';
import 'package:recipe_x/data/entities/ingredient.dart';
import 'package:recipe_x/data/entities/recipe.dart';

import 'dart:convert' as convert;
import 'package:recipe_x/data/entities/region.dart';

class Service {
  /// regions : a list of regions.
  /// path : 'recipes/regions.json'
  /// returns : a list of [Region]s.
  /// throws : [Exception] if Regions not found!

  Future<List<Region>> regions() async {
    try {
      final result = await foundation.compute(
          _computeRegions, await rootBundle.loadString('recipes/regions.json'));
      return result;
    } on Exception catch (_) {
      print('\x1B[31mError Loading Regions : $_\x1B[0m');
      throw Exception('Regions not found!');
    }
  }

  /// categories : a list of categories.
  /// path : 'recipes/categories.json'
  /// returns : a list of [Category]s.
  /// throws : [Exception] if Categories not found!

  Future<List<Category>> categories() async {
    try {
      final result = await foundation.compute(_computeCategories,
          await rootBundle.loadString('recipes/categories.json'));
      return result;
    } on Exception catch (_) {
      throw Exception('Categories not found!');
    }
  }

  /// ingredients : a list of ingredients.
  /// path : 'recipes/ingredients.json'
  /// returns : a list of [Ingredient]s.
  /// throws : [Exception] if Ingredients not found!

  Future<List<Ingredient>> ingredients() async {
    try {
      final result = await foundation.compute(_computeIngredients,
          await rootBundle.loadString('recipes/ingredients.json'));
      return result;
    } on Exception catch (_) {
      throw Exception('Ingredients not found!');
    }
  }

  /// recipes : a list of recipes.
  /// path : 'recipes/recipes.json'
  /// returns : a list of [Recipe]s.
  /// throws : [Exception] if Recipes not found!

  Future<List<Recipe>> recipes() async {
    try {
      final result = await foundation.compute(
          _computeRecipes, await rootBundle.loadString('recipes/recipes.json'));
      return result;
    } on Exception catch (_) {
      print(_);
      throw Exception('Recipes not found!');
    }
  }

  /// countries : a list of countries.
  /// path : 'recipes/countries.json'
  /// returns : a list of [Country]s.
  /// throws : [Exception] if Countries not found!
  /// source : https://cdn.jsdelivr.net/npm/country-flag-emoji-json@2.0.0/dist/index.json
  
  Future<List<Country>> countries() async {
    try {
      final result = await foundation.compute(_computeCountries,
          await rootBundle.loadString('recipes/countries.json'));
      return result;
    } on Exception catch (_) {
      throw Exception('Countries not found!');
    }
  }

  List<Country> _computeCountries(String content) {
    final json = convert.jsonDecode(content) as List<dynamic>;
    if (json.isNotEmpty) {
      return json
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList()
        ..shuffle();
    }
    return <Country>[];
  }

  List<Recipe> _computeRecipes(String content) {
    final json = convert.jsonDecode(content) as List<dynamic>;
    if (json.isNotEmpty) {
      return json
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList()
        ..shuffle();
    }
    return <Recipe>[];
  }

  List<Ingredient> _computeIngredients(String content) {
    final json = convert.jsonDecode(content) as List<dynamic>;
    if (json.isNotEmpty) {
      return json
          .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
          .toList()
        ..shuffle();
    }
    return <Ingredient>[];
  }

  List<Category> _computeCategories(String content) {
    final json = convert.jsonDecode(content) as List<dynamic>;
    if (json.isNotEmpty) {
      return json
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList()
        ..shuffle();
    }
    return <Category>[];
  }

  List<Region> _computeRegions(String content) {
    final json = convert.jsonDecode(content) as List<dynamic>;
    if (json.isNotEmpty) {
      return json
          .map((e) => Region.fromJson(e as Map<String, dynamic>))
          .toList()
        ..shuffle();
    }
    return <Region>[];
  }
}
