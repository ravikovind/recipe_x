part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();
  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {
  const LoadRecipes();
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
