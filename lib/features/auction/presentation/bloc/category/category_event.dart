part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  List<Object?> get props => [];
}

class CategoryStarted extends CategoryEvent {
  final AuctionCategory category;
  const CategoryStarted(this.category);
  @override
  List<Object?> get props => [category];
}

class CategorySearchChanged extends CategoryEvent {
  final String query;
  const CategorySearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class CategorySortChanged extends CategoryEvent {
  final CategorySort sort;
  const CategorySortChanged(this.sort);
  @override
  List<Object?> get props => [sort];
}
