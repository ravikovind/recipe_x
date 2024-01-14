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
    on<LoadRandomRecipes>(_onRecipeLoadRandom);
    on<FilterRecipes>(_onRecipeFilter);
  }

  final Service service;

  FutureOr<void> _onRecipeLoad(
      LoadRecipes event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(busy: true));
    try {
      final result = await service.recipes();
      emit(
        state.copyWith(
          recipes: [...result]..shuffle(),
          message: 'Recipes Loaded Successfully',
        ),
      );
      add(const LoadRandomRecipes());
    } on Exception catch (_) {
      emit(state.copyWith(error: 'Error Loading Recipes'));
    } finally {
      emit(state.copyWith(busy: false));
    }
  }

  FutureOr<void> _onRecipeLoadRandom(
      LoadRandomRecipes event, Emitter<RecipeState> emit) async {
    final old = state.recipes;
    var svgs = state.svgs;
    emit(
      state.copyWith(
        busy: true,
        randomRecipes: <Recipe>[],
        svgs: <String>[
          ...svgs,
        ]..shuffle(),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final random = old.take(11).toList()..shuffle();
    emit(
      state.copyWith(
        randomRecipes: random,
        svgs: [...svgs]..shuffle(),
        busy: false,
      ),
    );
  }

  FutureOr<void> _onRecipeFilter(
      FilterRecipes event, Emitter<RecipeState> emit) async {
    emit(state.copyWith(busy: true));
    try {
      if (event.query.isEmpty &&
          event.ingredients.isEmpty &&
          event.regions.isEmpty) {
        emit(
          state.copyWith(
            filteredRecipes: <Recipe>[],
            page: 1,
            limit: 20,
            busy: false,
          ),
        );
        return Future<void>.value();
      }

      if (event.refresh) {
        emit(
          state.copyWith(
            filteredRecipes: <Recipe>[],
            page: 1,
            limit: 20,
          ),
        );

        /// considering the search query is the recipe name
        final result = state.recipes.where((recipe) {
          final nameMatch =
              recipe.name?.toLowerCase().contains(event.query.toLowerCase()) ==
                  true;
          final ingredientsMatch = event.ingredients.isEmpty ||
              event.ingredients.any(
                  (element) => recipe.ingredients?.contains(element) == true);
          final regionsMatch = event.regions.isEmpty ||
              event.regions
                  .any((element) => recipe.region?.contains(element) == true);
          return nameMatch && ingredientsMatch && regionsMatch;
        }).toList();

        emit(
          state.copyWith(
            busy: false,
            filteredRecipes: [...result.take(state.limit)],
            message: 'Recipes Loaded Successfully',
          ),
        );
        return Future<void>.value();
      }

      if (state.hasReachedMax) {
        emit(
          state.copyWith(
            busy: false,
            error: 'No more recipes available for ${event.query}!',
          ),
        );
        return Future<void>.value();
      }

      final old = state.filteredRecipes;

      final result = state.recipes.where((recipe) {
        final nameMatch =
            recipe.name?.toLowerCase().contains(event.query.toLowerCase()) ==
                true;
        final ingredientsMatch = event.ingredients.isEmpty ||
            event.ingredients.any(
                (element) => recipe.ingredients?.contains(element) == true);
        final regionsMatch = event.regions.isEmpty ||
            event.regions
                .any((element) => recipe.region?.contains(element) == true);
        return nameMatch && ingredientsMatch && regionsMatch;
      }).toList();

      final filtered = result.skip(state.limit * state.page).take(state.limit);

      emit(
        state.copyWith(
          busy: false,
          filteredRecipes: [
            ...old,
            ...filtered,
          ],
          page: state.page + 1,
          hasReachedMax: filtered.length < state.limit || filtered.isEmpty,
        ),
      );
      return Future<void>.value();
    } on Exception catch (_) {
      emit(state.copyWith(error: 'Error Loading Recipes', busy: false));
    } finally {
      emit(state.copyWith(busy: false));
    }
  }
}
