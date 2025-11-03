part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<DrinkCartModel> cart;
  CartLoaded({required this.cart});
  int getTotalPrice() {
    final int totals = cart.fold<int>(0, (s, d) => s + d.getTotalPrice());
    return totals;
  }

  CartLoaded copyWith({List<DrinkCartModel>? cart}) {
    return CartLoaded(cart: cart ?? this.cart);
  }
}

class CartSubmitSuccessful extends CartState {
  final List<DrinkCartModel> cart;
  CartSubmitSuccessful({required this.cart});
}

class CartError extends CartState {}
