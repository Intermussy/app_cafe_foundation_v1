part of 'drink_bloc.dart';

@immutable
sealed class DrinkEvent {}

class DrinkInitialized extends DrinkEvent{}
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

abstract class DrinkUpdateQuantity extends DrinkEvent {
  final int changes;
  DrinkUpdateQuantity({required this.changes});
}

class DrinkIncrementQuantity extends DrinkUpdateQuantity {
  DrinkIncrementQuantity({required super.changes});
}

class DrinkDecrementQuantity extends DrinkUpdateQuantity {
  DrinkDecrementQuantity({required super.changes});
}
