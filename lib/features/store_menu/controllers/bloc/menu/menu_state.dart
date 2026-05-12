part of 'menu_bloc.dart';

@immutable
sealed class MenuState {}

final class MenuInitial extends MenuState {}

class MenuLoaded extends MenuState {
  final List<DrinkCatalogModel> allDrinks;
  final List<DrinkCatalogModel> filteredDrinks;
  final String selectedType;
  final String searchQuery;
  final int cartCount;
  MenuLoaded({
    required this.allDrinks,
    required this.selectedType,
    this.searchQuery = '',
    required this.cartCount,
    required this.filteredDrinks,
  });

  MenuLoaded copyWith({
    List<DrinkCatalogModel>? allDrinks,
    List<DrinkCatalogModel>? filteredDrinks,
    String? filter,
    String? search,
    int? cartCount,
  }) {
    return MenuLoaded(
      allDrinks: allDrinks ?? this.allDrinks,
      filteredDrinks: filteredDrinks ?? this.filteredDrinks,
      selectedType: filter ?? selectedType,
      searchQuery: search ?? searchQuery,
      cartCount: cartCount ?? this.cartCount,
    );
  }
}

class MenuLoading extends MenuState {}
