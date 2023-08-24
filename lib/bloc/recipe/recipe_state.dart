part of 'recipe_bloc.dart';

class RecipeState extends Equatable {
  const RecipeState({
    this.busy = false,
    this.recipes = const <Recipe>[],
    this.error = '',
    this.message = '',
  });
  final bool busy;
  final List<Recipe> recipes;
  final String error;
  final String message;

  RecipeState copyWith({
    bool? busy,
    List<Recipe>? recipes,
    String? error,
    String? message,
  }) {
    return RecipeState(
      busy: busy ?? this.busy,
      recipes: recipes ?? this.recipes,
      error: error ?? this.error,
      message: message ?? this.message,
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
  List<Object> get props => [busy, recipes, error, message];
}
