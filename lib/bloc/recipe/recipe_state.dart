part of 'recipe_bloc.dart';

class RecipeState extends Equatable {
  const RecipeState({
    this.busy = false,
    this.recipes = const <Recipe>[],
    this.randomRecipes = const <Recipe>[],
    this.svgs = svgsArray,
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

  /// randomRecipes is the list of recipes fetched from the database
  /// and shuffled
  final List<Recipe> randomRecipes;

  /// svgs is just illustrations for random recipes
  final List<String> svgs;

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
    List<Recipe>? randomRecipes,
    List<String>? svgs,
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
      randomRecipes: randomRecipes ?? this.randomRecipes,
      svgs: svgs ?? this.svgs,
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
          json['RecipeState']?.map((x) => Recipe.fromJson(x)) ?? <Recipe>[],
        ),
        randomRecipes: List<Recipe>.from(
          json['RecipeState11']?.map((x) => Recipe.fromJson(x)) ?? <Recipe>[],
        ),
      );

  /// toJson
  Map<String, dynamic> toJson() => {
        'RecipeState': recipes.map((x) => x.toJson()).toList(),
        'RecipeState11': randomRecipes.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object> get props => [
        busy,
        recipes,
        randomRecipes,
        svgs,
        error,
        message,
        limit,
        page,
        filteredRecipes,
        hasReachedMax
      ];
}

const svgsArray = <String>[
  'assets/svgs/1.svg.vec',
  'assets/svgs/2.svg.vec',
  'assets/svgs/3.svg.vec',
  'assets/svgs/4.svg.vec',
  'assets/svgs/5.svg.vec',
  'assets/svgs/6.svg.vec',
  'assets/svgs/7.svg.vec',
  'assets/svgs/8.svg.vec',
  'assets/svgs/9.svg.vec',
  'assets/svgs/10.svg.vec',
  'assets/svgs/11.svg.vec',
];
