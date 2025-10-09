part of 'drink_bloc.dart';

@immutable
sealed class DrinkEvent {}

class DrinkUpdateIceLevel extends DrinkEvent {
  final String ice;
  DrinkUpdateIceLevel({required this.ice});
}

class DrinkUpdateSugarLevel extends DrinkEvent {
  final String sugar;
  DrinkUpdateSugarLevel({required this.sugar});
}

class DrinkUpdateTempLevel extends DrinkEvent {
  final String temperature;
  DrinkUpdateTempLevel({required this.temperature});
}

class DrinkUpdateTopping extends DrinkEvent {
  final List<Topping> toppings;
  DrinkUpdateTopping({required this.toppings});
}

class DrinkUpdateSyrup extends DrinkEvent {
  final List<Syrup> syrups;
  DrinkUpdateSyrup({required this.syrups});
}

class DrinkSubmit extends DrinkEvent {}

class DrinkIncrementQuantity extends DrinkEvent {
  final int changes;
  DrinkIncrementQuantity({required this.changes});
}

class DrinkDecrementQuantity extends DrinkEvent {
  final int changes;
  DrinkDecrementQuantity({required this.changes});
}
