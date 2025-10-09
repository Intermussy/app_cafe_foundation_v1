part of 'drink_bloc.dart';

@immutable
sealed class DrinkState {}

final class DrinkInitial extends DrinkState {}

class DrinkLoading extends DrinkState {}

class DrinkErrorg extends DrinkState {
  final String error;
  DrinkErrorg({required this.error});
}

class DrinkSuccess extends DrinkState {}

class DrinkLoaded extends DrinkState {
  final DrinkDetailModel model;
  final String selectedSugar;
  final String selectedIce;
  final String selectedTemp;
  final List<Topping> selectedToppings;
  final List<Syrup> selectedSyrups;
  final int totalPrice;
  DrinkLoaded({
    required this.model,
    required this.selectedSugar,
    required this.selectedIce,
    required this.selectedTemp,
    this.selectedToppings = const [],
    this.selectedSyrups = const [],
    required this.totalPrice,
  });

  factory DrinkLoaded.initial(DrinkDetailModel model) {
    if (model.cartId != null) {
      return DrinkLoaded(
        model: model,
        selectedSugar: model.sugar,
        selectedIce: model.ice,
        selectedTemp: model.temp,
        selectedToppings: model.toppings,
        selectedSyrups: model.syrups,
        totalPrice: model.getTotalPrice(),
      );
    } else {
      return DrinkLoaded(
        model: model,
        selectedSugar: 'normal',
        selectedIce: model.canBeCold ? 'normal' : 'none',
        selectedTemp: model.canBeHot
            ? 'hot'
            : (model.canBeCold ? 'cold' : 'hot'),
        selectedToppings: model.toppings,
        selectedSyrups: model.syrups,
        totalPrice: model.getTotalPrice(),
      );
    }
  }

  int getTotalPrice() {
    int priceTopping = selectedToppings.fold<int>(0, (s, a) => s + a.price);
    int priceSyrup = selectedSyrups.fold<int>(0, (s, a) => s + a.price);

    return (model.quantity * (model.basePrice + priceSyrup + priceTopping));
  }

  DrinkLoaded copyWith({
    DrinkDetailModel? model,
    String? selectedSugar,
    String? selectedIce,
    String? selectedTemp,
    List<Topping>? selectedToppings,
    List<Syrup>? selectedSyrups,
    int? totalPrice,
  }) {
    return DrinkLoaded(
      model: model ?? this.model,
      selectedSugar: selectedSugar ?? this.selectedSugar,
      selectedIce: selectedIce ?? this.selectedIce,
      selectedTemp: selectedTemp ?? this.selectedTemp,
      selectedToppings: selectedToppings ?? this.selectedToppings,
      selectedSyrups: selectedSyrups ?? this.selectedSyrups,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
