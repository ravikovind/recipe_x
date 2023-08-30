import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:recipe_x/data/entities/region.dart';
import 'package:recipe_x/data/services/service.dart';

part 'region_event.dart';
part 'region_state.dart';

class RegionBloc extends HydratedBloc<RegionEvent, RegionState> {
  RegionBloc({
    required this.service,
  }) : super(const RegionState()) {
    on<LoadRegions>(_onRegionLoad);
  }

  final Service service;

  FutureOr<void> _onRegionLoad(
      LoadRegions event, Emitter<RegionState> emit) async {
    emit(state.copyWith(busy: true));
    try {
      var result = await service.regions();
      emit(
        state.copyWith(
          regions: [...result]
            ..sort((a, b) => b.popularity?.compareTo(a.popularity ?? 0) ?? 0),
          message: 'Regions Loaded Successfully',
        ),
      );
    } on Exception catch (_) {
      print('\x1B[31mError Loading Regions : $_\x1B[0m');
      emit(state.copyWith(error: 'Error Loading Regions'));
    } finally {
      emit(state.copyWith(busy: false));
    }
  }

  @override
  RegionState fromJson(Map<String, dynamic> json) => RegionState.fromJson(json);

  @override
  Map<String, dynamic> toJson(RegionState state) => state.toJson();
}
