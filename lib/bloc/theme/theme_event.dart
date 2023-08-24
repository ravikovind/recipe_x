part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'ToggleTheme';
}

class SetTheme extends ThemeEvent {
  final ThemeMode themeMode;
  const SetTheme({required this.themeMode});
  @override
  List<Object> get props => [themeMode];
  @override
  String toString() => 'SetTheme { themeMode: $themeMode }';
}
