import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:recipe_x/data/entities/category.dart';
import 'package:recipe_x/data/services/service.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends HydratedBloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required this.service,
  }) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
  }

  final Service service;

  FutureOr<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isBusy: true));
    try {
      final categories = await service.categories();
      emit(state.copyWith(
          categories: categories, message: 'Categories Loaded Successfully'));
    } on Exception catch (_) {
      print('\x1B[31mError Loading Categories : $_\x1B[0m');
      emit(state.copyWith(error: 'Error Loading Categories'));
    } finally {
      emit(state.copyWith(isBusy: false));
    }
  }

  @override
  CategoryState? fromJson(Map<String, dynamic> json) =>
      CategoryState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(CategoryState state) => state.toJson();
}
