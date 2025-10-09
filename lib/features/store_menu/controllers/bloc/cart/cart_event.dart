part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class RequestCartEvent extends CartEvent {}

class UpdateCartEvent extends CartEvent {}

class SubmitCartEvent extends CartEvent {}
