part of 'country_bloc.dart';

class CountryState extends Equatable {
  const CountryState({
    this.busy = false,
    this.error = '',
    this.message = '',
    this.countries = const <Country>[],
  });
  final bool busy;
  final String error;
  final String message;
  final List<Country> countries;

  CountryState copyWith({
    bool? busy,
    String? error,
    String? message,
    List<Country>? countries,
  }) {
    return CountryState(
      busy: busy ?? this.busy,
      error: error ?? this.error,
      message: message ?? this.message,
      countries: countries ?? this.countries,
    );
  }

  @override
  List<Object> get props => [busy, error, message, countries];
}
