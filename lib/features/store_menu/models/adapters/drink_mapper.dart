import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_source.dart';

extension FromCartX on FromCart {
  DrinkDetailModel toDetailModel() {
    final drink = cartDrink;
    return DrinkDetailModel(
      name: drink.name,
      image: drink.image,
      basePrice: drink.basePrice,
      quantity: drink.quantity,
      type: drink.type,
      tempLevel: drink.tempLevel,
      iceLevel: drink.iceLevel,
      sugarLevel: drink.sugarLevel,
      toppings: (drink.toppings),
      syrups: (drink.syrups),
      hotAvailable: drink.hotAvailable,
      iceAvailable: drink.iceAvailable,
      catalogId: drink.catalogId,
      cartId: drink.id,
    );
  }
}

extension FromMenuX on FromMenu {
  DrinkDetailModel toDetailModel() {
    final drink = menuDrink;
    return DrinkDetailModel(
      catalogId: drink.id,
      name: drink.name,
      image: drink.image,
      basePrice: drink.basePrice,
      quantity: 1,
      tempLevel: drink.hotAvailable ? 'hot' : 'cold',
      iceLevel: drink.iceAvailable ? 'normal' : 'none',
      sugarLevel: 'normal',
      toppings: [],
      syrups: [],
      hotAvailable: drink.hotAvailable,
      iceAvailable: drink.iceAvailable,
      type: drink.type,
    );
  }
}

extension BoolDbMapper on bool {
  int toDb() => this ? 1 : 0;
}

extension IntBoolMapper on Object? {
  bool toBool() {
    if (this is int) return (this as int) == 1;
    if (this is bool) return this as bool;
    if (this is String) return this == '1' || this == 'true';
    return false;
  }
}

extension CalculateTotalList on List<DrinkCartModel> {
  int getTotalPrice() =>
      fold<int>(0, (start, drink) => start + drink.getTotalPrice());
}

extension SnakeCaseCammelCaseMapper on Map<String, dynamic> {
  Map<String, dynamic> normalizeKeys(Map<String, dynamic> map) {
    return map.map((key, value) {
      final normalizedKey = key.replaceAllMapped(
        RegExp(r'_([a-z])'),
        (match) => match.group(1)!.toUpperCase(),
      );
      return MapEntry(normalizedKey, value);
    });
  }
}
