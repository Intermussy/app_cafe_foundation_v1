import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';

class DrinkDetailModel {
  final int id;
  final int? cartId;
  final String name;
  final String image;
  final int basePrice;
  final int quantity;
  final String type;
  final String temp;
  final String sugar;
  final String ice;
  final List<Topping> toppings;
  final List<Syrup> syrups;
  final bool canBeHot;
  final bool canBeCold;
  DrinkDetailModel({
    required this.temp,
    required this.id,
    this.cartId,
    required this.name,
    required this.image,
    required this.basePrice,
    required this.quantity,
    required this.type,
    required this.ice,
    required this.sugar,
    required this.canBeHot,
    required this.canBeCold,
    required this.toppings,
    required this.syrups,
  });

  int getTotalPrice() {
    int toppingsTotal = toppings.fold<int>(0, (sum, t) => sum + t.price);

    int syrupsTotal = syrups.fold<int>(0, (sum, s) => sum + s.price);

    // toppings/syrups apply PER drink
    return (quantity * (basePrice + toppingsTotal + syrupsTotal));
  }

  DrinkDetailModel copyWith({
    int? id,
    int? cartId,
    String? name,
    String? image,
    int? basePrice,
    int? quantity,
    String? type,
    String? ice,
    String? sugar,
    List<Topping>? toppings,
    List<Syrup>? syrups,
    bool? canBeHot,
    bool? canBeCold,
    String? temp,
  }) {
    return DrinkDetailModel(
      id: id ?? this.id,
      cartId: cartId ?? this.cartId,
      name: name ?? this.name,
      image: image ?? this.image,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      temp: temp ?? this.temp,
      ice: ice ?? this.ice,
      sugar: sugar ?? this.sugar,
      toppings: toppings ?? this.toppings,
      syrups: syrups ?? this.syrups,
      canBeHot: canBeHot ?? this.canBeHot,
      canBeCold: canBeCold ?? this.canBeCold,
    );
  }

  @override
  String toString() {
    return 'DrinkDetailModel(id: $id, cartId: $cartId, name: $name, image: $image, basePrice: $basePrice, quantity: $quantity, type: $type, temp: $temp, sugar: $sugar, ice: $ice, toppings: $toppings, syrups: $syrups, canBeHot: $canBeHot, canBeCold: $canBeCold)';
  }
}
