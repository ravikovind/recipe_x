part of 'recipe_bloc.dart';

class RecipeState extends Equatable {
  const RecipeState({
    this.busy = false,
    this.recipes = const <Recipe>[],
    this.error = '',
    this.message = '',
    this.limit = 20,
    this.page = 1,
    this.filteredRecipes = const <Recipe>[],
    this.hasReachedMax = false,
  });

  /// busy is true when the app is busy fetching data
  final bool busy;

  /// recipes is the list of recipes fetched from the database
  final List<Recipe> recipes;

  /// error is the error message
  final String error;

  /// message is the success message
  final String message;

  /// limit is the number of items to be fetched per page
  final int limit;

  /// page is the current page
  final int page;

  /// filteredRecipes is the list of recipes that match the search query or filter
  final List<Recipe> filteredRecipes;

  /// hasReachedMax is true when the maximum number of items has been reached
  final bool hasReachedMax;

  RecipeState copyWith({
    bool? busy,
    List<Recipe>? recipes,
    String? error,
    String? message,
    int? limit,
    int? page,
    List<Recipe>? filteredRecipes,
    bool? hasReachedMax,
  }) {
    return RecipeState(
      busy: busy ?? this.busy,
      recipes: recipes ?? this.recipes,
      error: error ?? this.error,
      message: message ?? this.message,
      limit: limit ?? this.limit,
      page: page ?? this.page,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  /// fromJson
  factory RecipeState.fromJson(Map<String, dynamic> json) => RecipeState(
        recipes: List<Recipe>.from(
            json['RecipeState']?.map((x) => Recipe.fromJson(x)) ?? <Recipe>[]),
      );

  /// toJson
  Map<String, dynamic> toJson() => {
        'RecipeState': recipes.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object> get props => [
        busy,
        recipes,
        error,
        message,
        limit,
        page,
        filteredRecipes,
        hasReachedMax
      ];
}
