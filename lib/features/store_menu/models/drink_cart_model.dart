import 'dart:convert';

import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';

abstract class DrinkCartBase {}

class DrinkCartDB extends DrinkCartBase {
  final int id;
  final int detailId;
  final String name;
  final int price;
  final int quantity;
  final String image;
  final String type;
  final String tempLevel;
  final String sugarLevel;
  final String iceLevel;
  final List<int> toppingIds;
  final List<int> syrupIds;
  final bool canBeHot;
  final bool canBeCold;
  DrinkCartDB({
    required this.id,
    required this.detailId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.type,
    required this.tempLevel,
    this.sugarLevel = 'none',
    this.iceLevel = 'none',
    required this.toppingIds,
    required this.syrupIds,
    required this.canBeHot,
    required this.canBeCold,
  });
  // int getTotalPrice() {
  //   final toppingsTotal = (toppingList).fold<int>(0, (sum, t) => sum + t.price);

  //   final syrupsTotal = (syrupList).fold<int>(0, (sum, s) => sum + s.price);

  //   // toppings/syrups apply PER drink
  //   return (quantity * (price + toppingsTotal + syrupsTotal));
  // }

  static DrinkCartDB getMockData() {
    return DrinkCartDB(
      id: 23,
      detailId: 32,
      name: "Americano",
      price: 15000,
      quantity: 2,
      image: 'assets/images/placeholder.png',
      toppingIds: [],
      canBeHot: true,
      canBeCold: true,
      tempLevel: 'cold',
      type: 'coffee',
      iceLevel: 'none',
      syrupIds: [],
    );
  }

  static List<DrinkCartDB> getMockList() {
    return [
      DrinkCartDB(
        name: "Americano",
        price: 15000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        iceLevel: 'less',
        toppingIds: [],
        canBeHot: true,
        canBeCold: true,
        tempLevel: 'cold',
        type: 'coffee',
        id: 12,
        detailId: 12,
        syrupIds: [],
      ),
      DrinkCartDB(
        name: "Babycchino",
        price: 20000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        canBeHot: true,
        canBeCold: false,
        tempLevel: 'hot',
        type: 'coffee',
        id: 123,
        detailId: 123,
        sugarLevel: 'normal',
        iceLevel: 'none',
        toppingIds: [],
        syrupIds: [],
      ),
      DrinkCartDB(
        name: "Avocado",
        price: 24000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        canBeHot: false,
        canBeCold: true,
        tempLevel: 'cold',
        type: 'non-cofee',
        id: 123,
        detailId: 123,
        sugarLevel: '',
        iceLevel: '',
        toppingIds: [],
        syrupIds: [],
      ),
    ];
  }

  DrinkCartDB copyWith({
    int? id,
    int? detailId,
    String? name,
    int? price,
    int? quantity,
    String? image,
    String? type,
    String? tempLevel,
    String? sugarLevel,
    String? iceLevel,
    List<int>? toppingIds,
    List<int>? syrupIds,
    bool? canBeHot,
    bool? canBeCold,
  }) {
    return DrinkCartDB(
      id: id ?? this.id,
      detailId: detailId ?? this.detailId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      type: type ?? this.type,
      tempLevel: tempLevel ?? this.tempLevel,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      iceLevel: iceLevel ?? this.iceLevel,
      toppingIds: toppingIds ?? this.toppingIds,
      syrupIds: syrupIds ?? this.syrupIds,
      canBeHot: canBeHot ?? this.canBeHot,
      canBeCold: canBeCold ?? this.canBeCold,
    );
  }

  factory DrinkCartDB.fromMemory(DrinkCartModel d) {
    return DrinkCartDB(
      id: d.id,
      detailId: d.detailId,
      name: d.name,
      price: d.price,
      quantity: d.quantity,
      image: d.image,
      type: d.type,
      tempLevel: d.tempLevel,
      toppingIds: d.toppings.map((t) => t.id).toList(),
      syrupIds: d.toppings.map((s) => s.id).toList(),
      canBeHot: d.canBeHot,
      canBeCold: d.canBeCold,
    );
  }
}

class DrinkCartModel extends DrinkCartBase {
  final int id;
  final int detailId;
  final String name;
  final int price;
  final int quantity;
  final String image;
  final String type;
  final String tempLevel;
  final String sugarLevel;
  final String iceLevel;
  final List<Topping> toppings;
  final List<Syrup> syrups;
  final bool canBeHot;
  final bool canBeCold;
  DrinkCartModel({
    required this.id,
    required this.detailId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.type,
    required this.tempLevel,
    required this.sugarLevel,
    required this.iceLevel,
    required this.toppings,
    required this.syrups,
    required this.canBeHot,
    required this.canBeCold,
  });

  int getTotalPrice() {
    int totalTopping = toppings.fold<int>(0, (sum, t) => (sum + t.price));
    int totalSyrup = syrups.fold<int>(0, (sum, s) => (sum + s.price));
    return ((totalTopping + totalSyrup + price) * quantity);
  }

  static List<DrinkCartModel> getMockList() {
    return <DrinkCartModel>[
      DrinkCartModel(
        id: 2,
        detailId: 2,
        name: 'americano',
        price: 13000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        type: 'coffee',
        tempLevel: 'hot',
        sugarLevel: 'normal',
        iceLevel: 'none',
        toppings: [],
        syrups: [],
        canBeHot: true,
        canBeCold: true,
      ),
      DrinkCartModel(
        name: "Babycchino",
        price: 20000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        canBeHot: true,
        canBeCold: false,
        tempLevel: 'hot',
        type: 'coffee',
        id: 123,
        detailId: 123,
        sugarLevel: 'normal',
        iceLevel: 'none',
        toppings: [],
        syrups: [],
      ),
      DrinkCartModel(
        name: "Avocado",
        price: 24000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        canBeHot: false,
        canBeCold: true,
        tempLevel: 'cold',
        type: 'non-cofee',
        id: 123,
        detailId: 123,
        sugarLevel: 'none',
        iceLevel: 'normal',
        toppings: [],
        syrups: [],
      ),
    ];
  }

  DrinkCartModel copyWith({
    int? id,
    int? detailId,
    String? name,
    int? price,
    int? quantity,
    String? image,
    String? type,
    String? tempLevel,
    String? sugarLevel,
    String? iceLevel,
    List<Topping>? toppings,
    List<Syrup>? syrups,
    bool? canBeHot,
    bool? canBeCold,
  }) {
    return DrinkCartModel(
      id: id ?? this.id,
      detailId: detailId ?? this.detailId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      type: type ?? this.type,
      tempLevel: tempLevel ?? this.tempLevel,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      iceLevel: iceLevel ?? this.iceLevel,
      toppings: toppings ?? this.toppings,
      syrups: syrups ?? this.syrups,
      canBeHot: canBeHot ?? this.canBeHot,
      canBeCold: canBeCold ?? this.canBeCold,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'detailId': detailId});
    result.addAll({'name': name});
    result.addAll({'price': price});
    result.addAll({'quantity': quantity});
    result.addAll({'image': image});
    result.addAll({'type': type});
    result.addAll({'tempLevel': tempLevel});
    result.addAll({'sugarLevel': sugarLevel});
    result.addAll({'iceLevel': iceLevel});
    result.addAll({'toppings': toppings.map((x) => x.toMap()).toList()});
    result.addAll({'syrups': syrups.map((x) => x.toMap()).toList()});
    result.addAll({'canBeHot': canBeHot});
    result.addAll({'canBeCold': canBeCold});

    return result;
  }

  factory DrinkCartModel.fromMap(Map<String, dynamic> map) {
    return DrinkCartModel(
      id: map['id']?.toInt() ?? 0,
      detailId: map['detailId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      image: map['image'] ?? '',
      type: map['type'] ?? '',
      tempLevel: map['tempLevel'] ?? '',
      sugarLevel: map['sugarLevel'] ?? '',
      iceLevel: map['iceLevel'] ?? '',
      toppings: List<Topping>.from(
        map['toppings']?.map((x) => Topping.fromMap(x)),
      ),
      syrups: List<Syrup>.from(map['syrups']?.map((x) => Syrup.fromMap(x))),
      canBeHot: map['canBeHot'] ?? false,
      canBeCold: map['canBeCold'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DrinkCartModel.fromJson(String source) =>
      DrinkCartModel.fromMap(json.decode(source));

  factory DrinkCartModel.fromDB(List<Topping> t, List<Syrup> s, DrinkCartDB d) {
    return DrinkCartModel(
      id: d.id,
      detailId: d.detailId,
      name: d.name,
      price: d.price,
      quantity: d.quantity,
      image: d.image,
      type: d.type,
      tempLevel: d.tempLevel,
      sugarLevel: d.sugarLevel,
      iceLevel: d.iceLevel,
      toppings: t,
      syrups: s,
      canBeHot: d.canBeHot,
      canBeCold: d.canBeCold,
    );
  }
  factory DrinkCartModel.initial(DrinkDetailModel d) {
    return DrinkCartModel(
      id: d.cartId ?? 0,
      detailId: d.id,
      name: d.name,
      price: d.basePrice,
      quantity: d.quantity,
      image: d.image,
      type: d.type,
      tempLevel: d.canBeHot ? 'hot' : 'cold',
      sugarLevel: 'normal',
      iceLevel: d.canBeCold ? 'normal' : 'none',
      toppings: [],
      syrups: [],
      canBeHot: d.canBeHot,
      canBeCold: d.canBeCold,
    );
  }
}
