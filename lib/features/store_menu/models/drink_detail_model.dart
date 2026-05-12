import 'package:app_foundation/features/store_menu/models/drink_base_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';

class DrinkDetailModel extends DrinkBaseModel {
  final int? cartId;
  final int catalogId;
  final int quantity;
  final String tempLevel;
  final String sugarLevel;
  final String iceLevel;
  final List<Topping> toppings;
  final List<Syrup> syrups;

  DrinkDetailModel({
    this.cartId,
    required super.name,
    required super.basePrice,
    required super.image,
    required super.iceAvailable,
    required super.hotAvailable,
    required super.type,
    required this.catalogId,
    required this.tempLevel,
    required this.sugarLevel,
    required this.iceLevel,
    required this.quantity,
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
    int? cartId,
    int? catalogId,
    String? name,
    int? basePrice,
    String? image,
    bool? iceAvailable,
    bool? hotAvailable,
    String? type,
    int? quantity,
    String? tempLevel,
    String? sugarLevel,
    String? iceLevel,
    List<Topping>? toppings,
    List<Syrup>? syrups,
  }) {
    return DrinkDetailModel(
      cartId: cartId ?? this.cartId,
      catalogId: catalogId ?? this.catalogId,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      image: image ?? this.image,
      iceAvailable: iceAvailable ?? this.iceAvailable,
      hotAvailable: hotAvailable ?? this.hotAvailable,
      type: '',
      quantity: quantity ?? this.quantity,
      tempLevel: tempLevel ?? this.tempLevel,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      iceLevel: iceLevel ?? this.iceLevel,
      toppings: toppings ?? this.toppings,
      syrups: syrups ?? this.syrups,
    );
  }
}
