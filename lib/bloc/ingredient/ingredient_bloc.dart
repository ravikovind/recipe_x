import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:recipe_x/data/entities/ingredient.dart';
import 'package:recipe_x/data/services/service.dart';

part 'ingredient_event.dart';
part 'ingredient_state.dart';

class IngredientBloc extends HydratedBloc<IngredientEvent, IngredientState> {
  IngredientBloc({
    required this.service,
  }) : super(const IngredientState()) {
    on<LoadIngredients>(_onLoadIngredients);
  }

  final Service service;

  FutureOr<void> _onLoadIngredients(
      LoadIngredients event, Emitter<IngredientState> emit) async {
    emit(state.copyWith(isBusy: true));
    try {
      final ingredients = await service.ingredients();
      emit(state.copyWith(ingredients: ingredients, message: 'Ingredients Loaded Successfully'));
    } on Exception catch (_) {
      emit(state.copyWith(error: 'Error Loading Ingredients'));
    } finally {
      emit(state.copyWith(isBusy: false));
    }
  }

  @override
  IngredientState? fromJson(Map<String, dynamic> json) =>
      IngredientState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(IngredientState state) => state.toJson();
}
