part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {
  const LoadRecipes({this.refresh = false});
  final bool refresh;
  @override
  List<Object> get props => [refresh];
}

class LoadRandomRecipes extends RecipeEvent {
  const LoadRandomRecipes({this.refresh = false});
  final bool refresh;
  @override
  List<Object> get props => [refresh];
}

class SelectRandomRecipe extends RecipeEvent {
  const SelectRandomRecipe({required this.recipe});
  final Recipe recipe;
  @override
  List<Object> get props => [recipe];
}

class FilterRecipes extends RecipeEvent {
  const FilterRecipes({
    this.query = '',
    this.refresh = false,
    this.regions = const <String>[],
    this.ingredients = const <String>[],
  });
  final String query;
  final bool refresh;
  final List<String> regions;
  final List<String> ingredients;

  @override
  List<Object> get props => [query, refresh, regions, ingredients];
}
