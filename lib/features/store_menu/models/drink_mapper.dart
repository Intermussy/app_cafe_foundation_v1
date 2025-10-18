import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_source.dart';

extension FromCartX on FromCart {
  DrinkDetailModel toDetailModel() {
    final drink = cartDrink;
    return DrinkDetailModel(
      name: drink.name,
      image: drink.image,
      basePrice: drink.price,
      quantity: drink.quantity,
      type: drink.type,
      temp: drink.tempLevel,
      ice: drink.iceLevel,
      sugar: drink.sugarLevel,
      toppings: (drink.toppings),
      syrups: (drink.syrups),
      canBeHot: drink.canBeHot,
      canBeCold: drink.canBeCold,
      id: drink.catalogId,
      cartId: drink.id,
    );
  }
}

extension FromMenuX on FromMenu {
  DrinkDetailModel toDetailModel() {
    final drink = menuDrink;
    return DrinkDetailModel(
      id: drink.id,
      name: drink.name,
      image: drink.image,
      basePrice: drink.price,
      quantity: 1,
      temp: drink.hotAvailable ? 'hot' : 'cold',
      ice: drink.iceAvailable ? 'normal' : 'none',
      sugar: 'normal',
      toppings: [],
      syrups: [],
      canBeHot: drink.hotAvailable,
      canBeCold: drink.iceAvailable,
      type: drink.type,
    );
  }
}

extension BoolDbMapper on bool {
  int toDb() => this ? 1 : 0;
}

extension IntBoolMapper on int {
  bool toBool() => this == 1;
}
