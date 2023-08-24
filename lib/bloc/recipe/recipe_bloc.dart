import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_x/data/entities/recipe.dart';
import 'package:recipe_x/data/services/service.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc({
    required this.service,
  }) : super(const RecipeState()) {
    on<LoadRecipes>(_onRecipeLoad);
  }

  final Service service;

  FutureOr<void> _onRecipeLoad(
      LoadRecipes event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(busy: true));
    try {
      final result = await service.recipes();
      emit(
        state.copyWith(
          recipes: [...result],
          message: 'Recipes Loaded Successfully',
        ),
      );
    } on Exception catch (_) {
      emit(state.copyWith(error: 'Error Loading Recipes'));
    } finally {
      emit(state.copyWith(busy: false));
    }
  }
}
