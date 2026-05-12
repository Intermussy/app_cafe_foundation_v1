// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:app_foundation/features/store_menu/controllers/bloc/drink_customization/drink_bloc.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/drink_base_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';

class DrinkCartDB {
  final int id;
  final int catalog_id;
  final String name;
  final int price;
  final int quantity;
  final String image;
  final String type;
  final String temp_level;
  final String sugar_level;
  final String ice_level;
  final int can_be_hot;
  final int can_be_cold;
  DrinkCartDB({
    required this.id,
    required this.catalog_id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.type,
    required this.temp_level,
    required this.sugar_level,
    required this.ice_level,
    required this.can_be_hot,
    required this.can_be_cold,
  });

  factory DrinkCartDB.fromMemory({required DrinkCartModel drink}) {
    return DrinkCartDB(
      id: drink.id,
      catalog_id: drink.catalogId,
      name: drink.name,
      price: drink.basePrice,
      quantity: drink.quantity,
      image: drink.image,
      type: drink.type,
      temp_level: drink.tempLevel,
      sugar_level: drink.sugarLevel,
      ice_level: drink.iceLevel,
      can_be_hot: drink.hotAvailable.toDb(),
      can_be_cold: drink.iceAvailable.toDb(),
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'catalog_id': catalog_id});
    result.addAll({'name': name});
    result.addAll({'price': price});
    result.addAll({'quantity': quantity});
    result.addAll({'image': image});
    result.addAll({'type': type});
    result.addAll({'temp_level': temp_level});
    result.addAll({'sugar_level': sugar_level});
    result.addAll({'ice_level': ice_level});
    result.addAll({'can_be_hot': can_be_hot});
    result.addAll({'can_be_cold': can_be_cold});

    return result;
  }

  factory DrinkCartDB.fromMap(Map<String, dynamic> map) {
    return DrinkCartDB(
      id: map['id']?.toInt() ?? 0,
      catalog_id: map['catalog_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      image: map['image'] ?? '',
      type: map['type'] ?? '',
      temp_level: map['temp_level'] ?? '',
      sugar_level: map['sugar_level'] ?? '',
      ice_level: map['ice_level'] ?? '',
      can_be_hot: map['can_be_hot']?.toInt() ?? 0,
      can_be_cold: map['can_be_cold']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DrinkCartDB.fromJson(String source) =>
      DrinkCartDB.fromMap(json.decode(source));
}

class DrinkCartModel extends DrinkBaseModel {
  final int id;
  final int catalogId;
  final int quantity;
  final String tempLevel;
  final String sugarLevel;
  final String iceLevel;
  final List<Topping> toppings;
  final List<Syrup> syrups;

  DrinkCartModel({
    int? id,
    required super.name,
    required super.basePrice,
    required super.image,
    required super.iceAvailable,
    required super.hotAvailable,
    required super.type,
    required this.catalogId,
    required this.quantity,
    required this.toppings,
    required this.syrups,
    required this.tempLevel,
    required this.sugarLevel,
    required this.iceLevel,
  }) : id = id ?? generateUniqueId();

  int getTotalPrice() {
    int totalTopping = toppings.fold<int>(0, (sum, t) => (sum + t.price));
    int totalSyrup = syrups.fold<int>(0, (sum, s) => (sum + s.price));
    return ((totalTopping + totalSyrup + basePrice) * quantity);
  }

  static List<DrinkCartModel> getMockList() {
    return <DrinkCartModel>[
      DrinkCartModel(
        id: 2,
        catalogId: 2,
        name: 'americano',
        basePrice: 13000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        type: 'coffee',
        tempLevel: 'hot',
        sugarLevel: 'normal',
        iceLevel: 'none',
        toppings: [],
        syrups: [],
        hotAvailable: true,
        iceAvailable: true,
      ),
      DrinkCartModel(
        name: "Babycchino",
        basePrice: 20000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        hotAvailable: true,
        iceAvailable: false,
        tempLevel: 'hot',
        type: 'coffee',
        id: 123,
        catalogId: 123,
        sugarLevel: 'normal',
        iceLevel: 'none',
        toppings: [],
        syrups: [],
      ),
      DrinkCartModel(
        name: "Avocado",
        basePrice: 24000,
        quantity: 1,
        image: 'assets/images/placeholder.png',
        hotAvailable: false,
        iceAvailable: true,
        tempLevel: 'cold',
        type: 'non-cofee',
        id: 123,
        catalogId: 123,
        sugarLevel: 'none',
        iceLevel: 'normal',
        toppings: [],
        syrups: [],
      ),
    ];
  }

  DrinkCartModel copyWith({
    int? id,
    int? catalogId,
    String? name,
    int? basePrice,
    int? quantity,
    String? image,
    String? type,
    String? tempLevel,
    String? sugarLevel,
    String? iceLevel,
    List<Topping>? toppings,
    List<Syrup>? syrups,
    bool? hotAvailable,
    bool? iceAvailable,
  }) {
    return DrinkCartModel(
      id: id ?? this.id,
      catalogId: catalogId ?? this.catalogId,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      type: type ?? this.type,
      tempLevel: tempLevel ?? this.tempLevel,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      iceLevel: iceLevel ?? this.iceLevel,
      toppings: toppings ?? this.toppings,
      syrups: syrups ?? this.syrups,
      hotAvailable: hotAvailable ?? this.hotAvailable,
      iceAvailable: iceAvailable ?? this.iceAvailable,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'detail_id': catalogId});
    result.addAll({'name': name});
    result.addAll({'price': basePrice});
    result.addAll({'quantity': quantity});
    result.addAll({'image': image});
    result.addAll({'type': type});
    result.addAll({'temp_level': tempLevel});
    result.addAll({'sugar_level': sugarLevel});
    result.addAll({'ice_level': iceLevel});
    result.addAll({'toppings': toppings.map((x) => x.toMap()).toList()});
    result.addAll({'syrups': syrups.map((x) => x.toMap()).toList()});
    result.addAll({'hot_available': hotAvailable});
    result.addAll({'ice_available': iceAvailable});

    return result;
  }

  factory DrinkCartModel.fromMap(Map<String, dynamic> map) {
    return DrinkCartModel(
      id: map['id']?.toInt() ?? 0,
      catalogId: map['detail_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      basePrice: map['price']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      image: map['image'] ?? '',
      type: map['type'] ?? '',
      tempLevel: map['temp_level'] ?? '',
      sugarLevel: map['sugar_level'] ?? '',
      iceLevel: map['ice_level'] ?? '',
      toppings: List<Topping>.from(
        map['toppings']?.map((x) => Topping.fromMap(x)),
      ),
      syrups: List<Syrup>.from(map['syrups']?.map((x) => Syrup.fromMap(x))),
      hotAvailable: map['hot_available'] ?? false,
      iceAvailable: map['ice_available'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory DrinkCartModel.fromJson(String source) =>
      DrinkCartModel.fromMap(json.decode(source));

  factory DrinkCartModel.fromDB(List<Topping> t, List<Syrup> s, DrinkCartDB d) {
    return DrinkCartModel(
      id: d.id,
      catalogId: d.catalog_id,
      name: d.name,
      basePrice: d.price,
      quantity: d.quantity,
      image: d.image,
      type: d.type,
      tempLevel: d.temp_level,
      sugarLevel: d.sugar_level,
      iceLevel: d.ice_level,
      toppings: t,
      syrups: s,
      hotAvailable: d.can_be_hot.toBool(),
      iceAvailable: d.can_be_cold.toBool(),
    );
  }
  factory DrinkCartModel.initial(DrinkDetailModel d) {
    return DrinkCartModel(
      id: d.cartId ?? 0,
      catalogId: d.catalogId,
      name: d.name,
      basePrice: d.basePrice,
      quantity: d.quantity,
      image: d.image,
      type: d.type,
      tempLevel: d.hotAvailable ? 'hot' : 'cold',
      sugarLevel: 'normal',
      iceLevel: d.iceAvailable ? 'normal' : 'none',
      toppings: [],
      syrups: [],
      hotAvailable: d.hotAvailable,
      iceAvailable: d.iceAvailable,
    );
  }

  static int generateUniqueId() {
    final timeStampe = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(900) + 100;
    return int.parse('$timeStampe$random');
  }

  factory DrinkCartModel.fromBloc(DrinkLoaded current) {
    return DrinkCartModel(
      name: current.model.name,
      basePrice: current.model.basePrice,
      image: current.model.image,
      iceAvailable: current.model.iceAvailable,
      hotAvailable: current.model.hotAvailable,
      type: current.model.type,
      catalogId: current.model.catalogId,
      quantity: current.model.quantity,
      toppings: current.selectedToppings,
      syrups: current.selectedSyrups,
      tempLevel: current.selectedTemp,
      sugarLevel: current.selectedSugar,
      iceLevel: current.selectedIce,
    );
  }
}
