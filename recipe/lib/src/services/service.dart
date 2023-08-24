import 'dart:io' as io;
import 'dart:convert' as convert;
import 'dart:isolate';

import 'package:path/path.dart' as path;
import 'package:recipe/src/entities/category.dart';
import 'package:recipe/src/entities/ingredient.dart';
import 'package:recipe/src/entities/recipe.dart';
import 'package:recipe/src/entities/region.dart';

class Service {
  /// _instance : a private static instance of [Service].
  /// _ : a private constructor of [Service].
  /// instance : a public static instance of [Service].
  /// returns : a static instance of [Service].
  static final Service _instance = Service._();
  Service._();
  static Service get instance => _instance;

  /// _directory : a variable that holds the current directory path.
  final _directory = io.Directory.current.path;

  /// regions : a list of regions.
  /// path : 'recipes/regions.json'
  /// returns : a list of [Region]s.
  /// throws : [Exception] if Regions not found!

  Future<List<Region>> regions() async {
    try {
      /// use isolate to read file
      /// along with json.decode

      final result = await Isolate.run(() async {
        final content =
            await io.File(path.join(_directory, 'recipes/regions.json'))
                .readAsString();

        /// use compute to decode json
        final json = convert.jsonDecode(content) as List<dynamic>;
        if (json.isNotEmpty) {
          return json
              .map((e) => Region.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return <Region>[];
      });
      return result;
    } on Exception catch (_) {
      throw Exception('Regions not found!');
    }
  }

  /// categories : a list of categories.
  /// path : 'recipes/categories.json'
  /// returns : a list of [Category]s.
  /// throws : [Exception] if Categories not found!

  Future<List<Category>> categories() async {
    try {
      final result = await Isolate.run(() async {
        final content =
            await io.File(path.join(_directory, 'recipes/categories.json'))
                .readAsString();
        final json = convert.jsonDecode(content) as List<dynamic>;
        if (json.isNotEmpty) {
          return json
              .map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return <Category>[];
      });
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
      final result = await Isolate.run(() async {
        final content =
            await io.File(path.join(_directory, 'recipes/ingredients.json'))
                .readAsString();
        final json = convert.jsonDecode(content) as List<dynamic>;
        if (json.isNotEmpty) {
          return json
              .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return <Ingredient>[];
      });
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
      final result = await Isolate.run(() async {
        final content =
            await io.File(path.join(_directory, 'recipes/recipes.json'))
                .readAsString();
        final json = convert.jsonDecode(content) as List<dynamic>;
        if (json.isNotEmpty) {
          return json
              .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return <Recipe>[];
      });
      return result;
    } on Exception catch (_) {
      print(_);
      throw Exception('Recipes not found!');
    }
  }
}
