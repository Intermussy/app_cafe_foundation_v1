import 'dart:convert';

import 'package:app_foundation/features/store_menu/models/adapters/addon_base.dart';

class Topping extends AddonBase {
  Topping({required super.id, required super.name, required super.price});

  static Topping getMockData() {
    return Topping(id: 2, name: "Caramel", price: 6000);
  }

  static List<Topping> getMockList() {
    final listMockTopping = [
      Topping(id: 3, name: "Caramel", price: 6000),
      Topping(id: 2, name: "Golden Boba", price: 6000),
      Topping(id: 1, name: "Oreo", price: 6000),
    ];
    return listMockTopping;
  }

  @override
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'price': price};

  factory Topping.fromMap(Map<String, dynamic> map) {
    return Topping(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Topping.fromJson(String source) =>
      Topping.fromMap(json.decode(source));

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
