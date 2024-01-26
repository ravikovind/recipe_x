import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_x/data/entities/country.dart';
import 'package:recipe_x/data/services/service.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc({
    required this.service,
  }) : super(const CountryState()) {
    on<LoadCountries>(_loadCountries);
  }

  final Service service;

  FutureOr<void> _loadCountries(
      LoadCountries event, Emitter<CountryState> emit) async {
    emit(state.copyWith(busy: true));
    try {
      final countries = await service.countries();

      /// sort countries by dial code. because dial less means more important.
      emit(state.copyWith(countries: <Country>[
        ...countries
          ..sort((a, b) {
            final aDial = int.tryParse('${a.dial}');
            final bDial = int.tryParse('${b.dial}');
            return aDial != null && bDial != null ? aDial.compareTo(bDial) : 0;
          })
      ]));
    } catch (e) {
      emit(state.copyWith(error: 'There was an error loading countries.'));
    } finally {
      emit(state.copyWith(busy: false));
    }
  }
}
