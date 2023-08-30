part of 'ingredient_bloc.dart';

class IngredientState extends Equatable {
  const IngredientState({
    this.ingredients = const <Ingredient>[],
    this.isBusy = false,
    this.error = '',
    this.message = '',
  });
  final List<Ingredient> ingredients;
  final bool isBusy;
  final String error;
  final String message;

  /// copyWith
  IngredientState copyWith({
    List<Ingredient>? ingredients,
    bool? isBusy,
    String? error,
    String? message,
  }) {
    return IngredientState(
      ingredients: ingredients ?? this.ingredients,
      isBusy: isBusy ?? this.isBusy,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  /// fromJson
  factory IngredientState.fromJson(Map<String, dynamic> json) =>
      IngredientState(
        ingredients: List<Ingredient>.from(json['IngredientState']
                ?.map((x) => Ingredient.fromJson(x)) ??
            <Ingredient>[]),
      );

  /// toJson
  Map<String, dynamic> toJson() => {
        'IngredientState': ingredients.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object> get props => [ingredients, isBusy, error, message];
}
