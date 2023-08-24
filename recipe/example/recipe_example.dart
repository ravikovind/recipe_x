import 'package:recipe/recipe.dart';

Future<void> main(List<String> args) async {
  final start = DateTime.now();
  final regions = await Recipes.instance.regions();
  final categories = await Recipes.instance.categories();
  final ingredients = await Recipes.instance.ingredients();
  final recipes = await Recipes.instance.recipes();
  print('Regions : ${regions.last}');
  print('Categories : ${categories.last}');
  print('Ingredients : ${ingredients.last}');
  print('Recipes : ${recipes.last}');
  final end = DateTime.now();
  print('Duration : ${end.difference(start).inMilliseconds} ms');
}
