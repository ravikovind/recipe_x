import 'package:recipe/src/entities/ingredient.dart';

import 'entities/category.dart';
import 'entities/recipe.dart';
import 'entities/region.dart';
import 'services/service.dart';

class Recipes {
  /// _instance : a private static instance of [Recipes].
  /// _ : a private constructor of [Recipes].
  /// instance : a public static instance of [Recipes].
  /// returns : a static instance of [Recipes].
  static final Recipes _instance = Recipes._();
  Recipes._();
  static Recipes get instance => _instance;

  /// regions : a list of regions.
  /// returns : a list of [Region]s.
  /// throws : [Exception] if Regions not found!
  Future<List<Region>> regions() => Service.instance.regions();

  /// categories : a list of categories.
  /// returns : a list of [Category]s.
  /// throws : [Exception] if Categories not found!
  Future<List<Category>> categories() => Service.instance.categories();

  /// ingredients : a list of ingredients.
  /// returns : a list of [Ingredient]s.
  /// throws : [Exception] if Ingredients not found!
  Future<List<Ingredient>> ingredients() => Service.instance.ingredients();

  /// recipes : a list of recipes.
  /// returns : a list of [Recipe]s.
  /// throws : [Exception] if Recipes not found!
  Future<List<Recipe>> recipes() => Service.instance.recipes();
}
