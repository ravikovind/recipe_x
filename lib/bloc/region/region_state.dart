part of 'region_bloc.dart';

class RegionState extends Equatable {
  const RegionState({
    this.busy = false,
    this.regions = const <Region>[],
    this.error = '',
    this.message = '',
  });
  final bool busy;
  final List<Region> regions;
  final String error;
  final String message;

  /// copyWith
  RegionState copyWith({
    bool? busy,
    List<Region>? regions,
    String? error,
    String? message,
  }) {
    return RegionState(
      busy: busy ?? this.busy,
      regions: regions ?? this.regions,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  /// fromJson
  factory RegionState.fromJson(Map<String, dynamic> json) => RegionState(
        regions: List<Region>.from(
            json['RegionState']?.map((x) => Region.fromJson(x)) ?? <Region>[]),
      );

  /// toJson
  Map<String, dynamic> toJson() => {
        'RegionState': regions.map((x) => x.toJson()).toList(),
      };


  @override
  List<Object> get props => [busy, regions, error, message];
}
