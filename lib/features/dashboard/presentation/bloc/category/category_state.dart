part of 'category_bloc.dart';

enum CategoryStatus { initial, loading, loaded, failure }

class CategoryState extends Equatable {
  final CategoryStatus status;
  final List<AuctionItem> items;
  final String query;
  final CategorySort sort;
  final String? errorMessage;

  const CategoryState({
    this.status = CategoryStatus.initial,
    this.items = const [],
    this.query = '',
    this.sort = CategorySort.endingSoon,
    this.errorMessage,
  });

  CategoryState copyWith({
    CategoryStatus? status,
    List<AuctionItem>? items,
    String? query,
    CategorySort? sort,
    String? errorMessage,
  }) => CategoryState(
    status: status ?? this.status,
    items: items ?? this.items,
    query: query ?? this.query,
    sort: sort ?? this.sort,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, items, query, sort, errorMessage];
}
