import 'dart:async';

import 'package:app_foundation/features/store_menu/models/drink_catalog_model.dart';
import 'package:app_foundation/features/store_menu/repositories/addon_repository.dart';
import 'package:app_foundation/features/store_menu/repositories/cart_repository.dart';
import 'package:app_foundation/features/store_menu/repositories/catalog_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final CartRepository _cartRepo = CartRepository();
  final CatalogRepository _catalogRepo = CatalogRepository();
  final AddonRepository _addonRepo = AddonRepository();

  MenuBloc() : super(MenuInitial()) {
    //handle startup menu
    on<LoadMenuEvent>(_onLoadMenu);

    //handle search keyword
    on<MenuSeachEvent>(_onSearchMenu);

    //handle filter by type preset
    on<MenuFilterTypeEvent>(_onFilterType);
  }

  FutureOr<void> _onLoadMenu(
    LoadMenuEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    final drinks = await _catalogRepo.readAll();
    final type = 'all';
    final cartCount = await _cartRepo.getCount();
    await _addonRepo.readAll();
    emit(
      MenuLoaded(
        allDrinks: drinks,
        filteredDrinks: drinks,
        selectedType: type,
        cartCount: cartCount,
      ),
    );
  }

  FutureOr<void> _onSearchMenu(
    MenuSeachEvent event,
    Emitter<MenuState> emit,
  ) async {
    //Eliminate other MenuState
    if (state is! MenuLoaded) return;

    //assign current state
    final current = state as MenuLoaded;

    //tell user to wait
    emit(MenuLoading());

    //convert search keyword to lowercase
    final query = event.query.toLowerCase();

    //map all available drinks with user's condition
    final filtered = current.allDrinks.where((d) {
      final matchesName = d.name.toLowerCase().contains(query);
      final matchesType =
          current.selectedType == 'all' || d.type == current.selectedType;
      return matchesName && matchesType;
    }).toList();

    //send filter result
    emit(current.copyWith(search: query, filteredDrinks: filtered));
  }

  FutureOr<void> _onFilterType(
    MenuFilterTypeEvent event,
    Emitter<MenuState> emit,
  ) async {
    if (state is! MenuLoaded) return;
    final current = state as MenuLoaded;
    emit(MenuLoading());
    final filtered = current.allDrinks.where((d) {
      final matchesType = event.type == 'all';
      d.type == event.type;
      final matchesSearch = d.name.toLowerCase().contains(
        current.searchQuery.toLowerCase(),
      );
      return matchesType && matchesSearch;
    }).toList();

    emit(current.copyWith(filter: event.type, filteredDrinks: filtered));
  }
}
