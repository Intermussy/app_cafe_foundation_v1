import 'dart:async';

import 'package:app_foundation/commons/widgets/event_transformer_helper.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/repositories/cart_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _repo = CartRepository();

  CartBloc() : super(CartInitial()) {
    on<RequestCartEvent>(requestCartEvent, transformer: sequential());
    on<UpdateCartQuantity>(updateQuantity);
    on<WriteToDB>(updateToDB, transformer: sequential());
    on<SubmitCartEvent>(submitCart);
    on<CartAbort>(onAbortCart, transformer: sequential());
  }

  Future<void> requestCartEvent(
    RequestCartEvent event,
    Emitter<CartState> emit,
  ) async {
    //TODO: load DrinkCartModel from SQLITE and map it to InMemoryDrinkCartModel
    emit(CartLoading());
    final List<DrinkCartModel> cart = await _repo.readAll();
    emit(CartLoaded(cart: cart));
  }

  FutureOr<void> updateQuantity(
    UpdateCartQuantity event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is CartLoaded) {
      final updatedCart = current.cart.map((d) {
        if (d.id == event.drink.id) {
          int newQuantity = d.quantity;
          if (event is IncrementCart) {
            newQuantity++;
          } else if (event is DecrementCart) {
            if (newQuantity <= 0) {
              add(CartAbort(item: event.drink));
            } else {
              newQuantity--;
            }
          }
          return d.copyWith(quantity: newQuantity);
        }
        return d;
      }).toList();
      emit(current.copyWith(cart: updatedCart));
      add(WriteToDB(updatedCart: updatedCart));
    }
  }

  FutureOr<void> submitCart(
    SubmitCartEvent event,
    Emitter<CartState> emit,
  ) async {
    bool success = await _repo.overWriteAll(event.drinks);
    if (success) {
      emit(CartSubmitSuccessful(cart: event.drinks));
    } else {
      emit(CartError());
    }
  }

  FutureOr<void> updateToDB(WriteToDB event, Emitter<CartState> emit) async {
    await _repo.overWriteAll(event.updatedCart);
  }

  FutureOr<void> onAbortCart(CartAbort event, Emitter<CartState> emit) async {
    await _repo.removeById(id: event.item.id);
    add(RequestCartEvent());
  }
}
