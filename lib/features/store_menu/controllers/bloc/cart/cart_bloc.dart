import 'dart:async';

import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<RequestCartEvent>(requestCartEvent);
    on<UpdateCartEvent>(updateCartEvent);
  }

  FutureOr<void> requestCartEvent(
    RequestCartEvent event,
    Emitter<CartState> emit,
  ) {
    //TODO: load DrinkCartModel from SQLITE and map it to InMemoryDrinkCartModel
  }

  FutureOr<void> updateCartEvent(
    UpdateCartEvent event,
    Emitter<CartState> emit,
  ) {
    //TODO: update from InMemoryDrinkCart and map it to SQLITE
  }
}
