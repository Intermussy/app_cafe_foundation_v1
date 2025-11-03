// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:app_foundation/bindings/app_logger.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';

class DrinkCatalogModel {
  final int id;
  final String name;
  final int price;
  final String image;
  final bool iceAvailable;
  final bool hotAvailable;
  final bool regularSizeAvailable;
  final bool largeSizeAvailable;
  final String type;

  DrinkCatalogModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.iceAvailable,
    required this.hotAvailable,
    required this.regularSizeAvailable,
    required this.largeSizeAvailable,
    required this.type,
  });

  static List<DrinkCatalogModel> getMockList() {
    return [
      DrinkCatalogModel(
        id: 1,
        name: 'Cappucino',
        price: 20000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: true,
        regularSizeAvailable: true,
        largeSizeAvailable: true,
        type: 'Coffee',
      ),
      DrinkCatalogModel(
        id: 2,
        name: 'Pistachio',
        price: 32000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: true,
        regularSizeAvailable: true,
        largeSizeAvailable: false,
        type: 'Coffee',
      ),
      DrinkCatalogModel(
        id: 3,
        name: 'Vanilla Frappe',
        price: 24000,
        image: 'assets/images/placeholder.png',
        iceAvailable: true,
        hotAvailable: false,
        regularSizeAvailable: true,
        largeSizeAvailable: false,
        type: 'Non-coffee',
      ),
    ];
  }

  DrinkCatalogModel copyWith({
    int? id,
    String? name,
    int? price,
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
      price: price ?? this.price,
      image: image ?? this.image,
      iceAvailable: iceAvailable ?? this.iceAvailable,
      hotAvailable: hotAvailable ?? this.hotAvailable,
      regularSizeAvailable: regularSizeAvailable ?? this.regularSizeAvailable,
      largeSizeAvailable: largeSizeAvailable ?? this.largeSizeAvailable,
      type: type ?? this.type,
    );
  }

  factory DrinkCatalogModel.fromDB(DrinkCatalogDB d) {
    AppLogger().info(d.toMap().toString());
    return DrinkCatalogModel(
      id: d.id,
      name: d.name,
      price: d.price,
      image: d.image,
      iceAvailable: d.ice_available.toBool(),
      hotAvailable: d.hot_available.toBool(),
      regularSizeAvailable: d.regular_size_available.toBool(),
      largeSizeAvailable: d.large_size_available.toBool(),
      type: d.type,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'price': price});
    result.addAll({'image': image});
    result.addAll({'iceAvailable': iceAvailable});
    result.addAll({'hotAvailable': hotAvailable});
    result.addAll({'regularSizeAvailable': regularSizeAvailable});
    result.addAll({'largeSizeAvailable': largeSizeAvailable});
    result.addAll({'type': type});

    return result;
  }

  factory DrinkCatalogModel.fromMap(Map<String, dynamic> map) {
    return DrinkCatalogModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      image: map['image'] ?? '',
      iceAvailable: map['ice_available'] ?? false,
      hotAvailable: map['hot_available'] ?? false,
      regularSizeAvailable: map['regular_size_available'] ?? false,
      largeSizeAvailable: map['large_size_available'] ?? false,
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
  final int price;
  final String image;
  final int ice_available;
  final int hot_available;
  final int regular_size_available;
  final int large_size_available;
  final String type;
  DrinkCatalogDB({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.ice_available,
    required this.hot_available,
    required this.regular_size_available,
    required this.large_size_available,
    required this.type,
  });

  DrinkCatalogDB copyWith({
    int? id,
    String? name,
    int? price,
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
      price: price ?? this.price,
      image: image ?? this.image,
      ice_available: iceAvailable ?? ice_available,
      hot_available: hotAvailable ?? hot_available,
      regular_size_available: regularSizeAvailable ?? regular_size_available,
      large_size_available: largeSizeAvailable ?? large_size_available,
      type: type ?? this.type,
    );
  }

  factory DrinkCatalogDB.fromMemory(DrinkCatalogModel d) {
    AppLogger().debug('[CATALOG fromMemory]${d.toMap().toString()}');
    return DrinkCatalogDB(
      id: d.id,
      name: d.name,
      price: d.price,
      image: d.image,
      ice_available: d.iceAvailable.toDb(),
      hot_available: d.hotAvailable.toDb(),
      regular_size_available: d.regularSizeAvailable.toDb(),
      large_size_available: d.largeSizeAvailable.toDb(),
      type: d.type,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'price': price});
    result.addAll({'image': image});
    result.addAll({'ice_available': ice_available});
    result.addAll({'hot_available': hot_available});
    result.addAll({'regular_size_available': regular_size_available});
    result.addAll({'large_size_available': large_size_available});
    result.addAll({'type': type});

    return result;
  }

  factory DrinkCatalogDB.fromMap(Map<String, dynamic> map) {
    return DrinkCatalogDB(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      price: map['price']?.toInt() ?? 0,
      image: map['image'] ?? '',
      ice_available: map['ice_available']?.toInt() ?? 0,
      hot_available: map['hot_available']?.toInt() ?? 0,
      regular_size_available: map['regular_size_available']?.toInt() ?? 0,
      large_size_available: map['large_size_available']?.toInt() ?? 0,
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DrinkCatalogDB.fromJson(String source) =>
      DrinkCatalogDB.fromMap(json.decode(source));
}
