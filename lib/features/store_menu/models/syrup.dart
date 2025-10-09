import 'dart:convert';

import 'package:app_foundation/features/store_menu/models/addon_base.dart';

class Syrup extends AddonItem {
  Syrup({required super.id, required super.name, required super.price});

  static List<Syrup> getMockList() {
    final listMockSyrup = [
      Syrup(id: 1, name: "Whipped Cream", price: 3000),
      Syrup(id: 2, name: "Vanilla Syrup", price: 3000),
      Syrup(id: 3, name: "Oreo", price: 3000),
    ];
    return listMockSyrup;
  }

  @override
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'price': price};

  factory Syrup.fromMap(Map<String, dynamic> map) {
    return Syrup(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Syrup.fromJson(String source) => Syrup.fromMap(json.decode(source));
}
