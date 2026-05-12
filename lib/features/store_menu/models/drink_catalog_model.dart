// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/drink_base_model.dart';

class DrinkCatalogModel extends DrinkBaseModel {
  final int id;
  DrinkCatalogModel({
    required this.id,
    required super.name,
    required super.basePrice,
    required super.image,
    required super.iceAvailable,
    required super.hotAvailable,
    required super.type,
  });
  static List<DrinkCatalogModel> getMockList() {
    return [
      DrinkCatalogModel(
        id: 1,
        name: 'Cappucino',
        basePrice: 20000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: true,

        type: 'Coffee',
      ),
      DrinkCatalogModel(
        id: 2,
        name: 'Pistachio',
        basePrice: 32000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: true,

        type: 'Coffee',
      ),
      DrinkCatalogModel(
        id: 3,
        name: 'Vanilla Frappe',
        basePrice: 24000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: false,

        type: 'Non-coffee',
      ),
    ];
  }

  DrinkCatalogModel copyWith({
    int? id,
    String? name,
    int? basePrice,
    String? image,
    bool? iceAvailable,
    bool? hotAvailable,
    bool? regularSizeAvailable,
    bool? largeSizeAvailable,
    String? type,
  }) {
    return DrinkCatalogModel(
      id: id ?? this.id,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      image: image ?? this.image,
      iceAvailable: iceAvailable ?? this.iceAvailable,
      hotAvailable: hotAvailable ?? this.hotAvailable,

      type: type ?? this.type,
    );
  }

  factory DrinkCatalogModel.fromDB(DrinkCatalogDB d) {
    return DrinkCatalogModel(
      id: d.id,
      name: d.name,
      basePrice: d.basePrice,
      image: d.image,
      iceAvailable: d.ice_available.toBool(),
      hotAvailable: d.hot_available.toBool(),

      type: d.type,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'basePrice': basePrice});
    result.addAll({'image': image});
    result.addAll({'iceAvailable': iceAvailable});
    result.addAll({'hotAvailable': hotAvailable});

    result.addAll({'type': type});

    return result;
  }

  factory DrinkCatalogModel.fromMap(Map<String, dynamic> map) {
    return DrinkCatalogModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      basePrice: map['basePrice']?.toInt() ?? 0,
      image: map['image'] ?? '',
      iceAvailable: map['ice_available'] ?? false,
      hotAvailable: map['hot_available'] ?? false,

      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DrinkCatalogModel.fromJson(String source) =>
      DrinkCatalogModel.fromMap(json.decode(source));
}

class DrinkCatalogDB {
  final int id;
  final String name;
  final int basePrice;
  final String image;
  final int ice_available;
  final int hot_available;
  final String type;
  DrinkCatalogDB({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.image,
    required this.ice_available,
    required this.hot_available,

    required this.type,
  });

  DrinkCatalogDB copyWith({
    int? id,
    String? name,
    int? basePrice,
    String? image,
    int? iceAvailable,
    int? hotAvailable,
    int? regularSizeAvailable,
    int? largeSizeAvailable,
    String? type,
  }) {
    return DrinkCatalogDB(
      id: id ?? this.id,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      image: image ?? this.image,
      ice_available: iceAvailable ?? ice_available,
      hot_available: hotAvailable ?? hot_available,

      type: type ?? this.type,
    );
  }

  factory DrinkCatalogDB.fromMemory(DrinkCatalogModel d) {
    return DrinkCatalogDB(
      id: d.id,
      name: d.name,
      basePrice: d.basePrice,
      image: d.image,
      ice_available: d.iceAvailable.toDb(),
      hot_available: d.hotAvailable.toDb(),

      type: d.type,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'basePrice': basePrice});
    result.addAll({'image': image});
    result.addAll({'ice_available': ice_available});
    result.addAll({'hot_available': hot_available});

    result.addAll({'type': type});

    return result;
  }

  factory DrinkCatalogDB.fromMap(Map<String, dynamic> map) {
    return DrinkCatalogDB(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      basePrice: map['basePrice']?.toInt() ?? 0,
      image: map['image'] ?? '',
      ice_available: map['ice_available']?.toInt() ?? 0,
      hot_available: map['hot_available']?.toInt() ?? 0,

      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DrinkCatalogDB.fromJson(String source) =>
      DrinkCatalogDB.fromMap(json.decode(source));
}
