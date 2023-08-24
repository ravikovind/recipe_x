import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ToggleTheme>(_onToggleTheme);
    on<SetTheme>(_onSetTheme);
  }
  FutureOr<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeMode> emit) {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }

  FutureOr<void> _onSetTheme(SetTheme event, Emitter<ThemeMode> emit) {
    emit(event.themeMode);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) =>
      ThemeMode.values[int.tryParse('${json['ThemeMode']}') ?? 0];
  @override
  Map<String, dynamic>? toJson(ThemeMode state) => {'ThemeMode': state.index};
}
