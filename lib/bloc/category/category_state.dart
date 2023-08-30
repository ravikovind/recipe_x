part of 'category_bloc.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.categories = const <Category>[],
    this.isBusy = false,
    this.error = '',
    this.message = '',
  });
  final List<Category> categories;
  final bool isBusy;
  final String error;
  final String message;

  /// copyWith
  CategoryState copyWith({
    List<Category>? categories,
    bool? isBusy,
    String? error,
    String? message,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isBusy: isBusy ?? this.isBusy,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  /// fromJson
  factory CategoryState.fromJson(Map<String, dynamic> json) => CategoryState(
        categories: List<Category>.from(json['CategoryState']
                ?.map((x) => Category.fromJson(x)) ??
            <Category>[]),
      );
  
  /// toJson
  Map<String, dynamic> toJson() => {
        'CategoryState': categories.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object> get props => [categories, isBusy, error, message];
}
