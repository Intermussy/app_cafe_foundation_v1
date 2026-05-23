// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:app_foundation/features/store_menu/controllers/bloc/drink_customization/drink_bloc.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/drink_base_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';

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

  factory DrinkCartModel.fromDB(
    Map<String, dynamic> map, {
    List<Topping> toppings = const [],
    List<Syrup> syrups = const [],
  }) {
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
      toppings: List<Topping>.from(toppings),
      syrups: List<Syrup>.from(syrups),
      hotAvailable: map['can_be_hot'] == 1,
      iceAvailable: map['can_be_cold'] == 1,
    );
  }

  Map<String, dynamic> toDB() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'catalog_id': catalogId});
    result.addAll({'name': name});
    result.addAll({'price': basePrice});
    result.addAll({'quantity': quantity});
    result.addAll({'image': image});
    result.addAll({'type': type});
    result.addAll({'temp_level': tempLevel});
    result.addAll({'sugar_level': sugarLevel});
    result.addAll({'ice_level': iceLevel});
    result.addAll({'can_be_hot': hotAvailable.toDb()});
    result.addAll({'can_be_cold': iceAvailable.toDb()});

    return result;
  }

  String toJson() => json.encode(toMap());

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
