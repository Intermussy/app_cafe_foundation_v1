part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class RequestCartEvent extends CartEvent {}

class CartAbort extends CartEvent {
  final DrinkCartModel item;
  CartAbort({required this.item});
}

sealed class UpdateCartQuantity extends CartEvent {
  final DrinkCartModel drink;

  UpdateCartQuantity({required this.drink});
}

class IncrementCart extends UpdateCartQuantity {
  IncrementCart({required super.drink});
}

class DecrementCart extends UpdateCartQuantity {
  DecrementCart({required super.drink});
}

class WriteToDB extends CartEvent {
  final List<DrinkCartModel> updatedCart;
  WriteToDB({required this.updatedCart});
}

class SubmitCartEvent extends CartEvent {
  final List<DrinkCartModel> drinks;
  SubmitCartEvent({required this.drinks});
}
