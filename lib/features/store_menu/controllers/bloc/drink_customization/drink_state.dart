part of 'drink_bloc.dart';

@immutable
sealed class DrinkState {}

final class DrinkInitial extends DrinkState {}

class DrinkLoading extends DrinkState {}

class DrinkError extends DrinkState {
  final String error;
  DrinkError({required this.error});
}

class DrinkSuccess extends DrinkState {
  final DrinkCartModel newDrink;
  DrinkSuccess({required this.newDrink});
}

class DrinkLoaded extends DrinkState {
  final DrinkDetailModel model;
  final String selectedSugar;
  final String selectedIce;
  final String selectedTemp;
  final List<Topping> selectedToppings;
  final List<Syrup> selectedSyrups;
  final int totalPrice;
  final List<Topping> availableToppings;
  final List<Syrup> availableSyrups;
  final bool isAddonLoading;
  DrinkLoaded({
    required this.model,
    required this.selectedSugar,
    required this.selectedIce,
    required this.selectedTemp,
    this.selectedToppings = const [],
    this.selectedSyrups = const [],
    required this.totalPrice,
    required this.availableToppings,
    required this.availableSyrups,
    this.isAddonLoading = false,
  });

  factory DrinkLoaded.initial(DrinkDetailModel model) {
    if (model.cartId != null) {
      return DrinkLoaded(
        model: model,
        selectedSugar: model.sugarLevel,
        selectedIce: model.iceLevel,
        selectedTemp: model.tempLevel,
        selectedToppings: model.toppings,
        selectedSyrups: model.syrups,
        totalPrice: model.getTotalPrice(),
        availableToppings: [],
        availableSyrups: [],
      );
    } else {
      return DrinkLoaded(
        model: model,
        selectedSugar: 'normal',
        selectedIce: model.iceAvailable ? 'normal' : 'none',
        selectedTemp: model.hotAvailable
            ? 'hot'
            : (model.iceAvailable ? 'cold' : 'hot'),
        selectedToppings: model.toppings,
        selectedSyrups: model.syrups,
        totalPrice: model.getTotalPrice(),
        availableToppings: [],
        availableSyrups: [],
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
    List<Topping>? availableToppings,
    List<Syrup>? availableSyrups,
    bool? isAddonLoading,
  }) {
    return DrinkLoaded(
      model: model ?? this.model,
      selectedSugar: selectedSugar ?? this.selectedSugar,
      selectedIce: selectedIce ?? this.selectedIce,
      selectedTemp: selectedTemp ?? this.selectedTemp,
      selectedToppings: selectedToppings ?? this.selectedToppings,
      selectedSyrups: selectedSyrups ?? this.selectedSyrups,
      totalPrice: totalPrice ?? this.totalPrice,
      availableToppings: availableToppings ?? this.availableToppings,
      availableSyrups: availableSyrups ?? this.availableSyrups,
      isAddonLoading: isAddonLoading ?? this.isAddonLoading,
    );
  }
}
