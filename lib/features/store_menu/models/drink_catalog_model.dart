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

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'price': basePrice});
    result.addAll({'image': image});
    result.addAll({'iceAvailable': iceAvailable});
    result.addAll({'hotAvailable': hotAvailable});
    result.addAll({'type': type});

    return result;
  }

  Map<String, dynamic> toDB() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'price': basePrice});
    result.addAll({'image': image});
    result.addAll({'ice_available': iceAvailable.toDb()});
    result.addAll({'hot_available': hotAvailable.toDb()});
    result.addAll({'type': type});

    return result;
  }

  factory DrinkCatalogModel.fromDB(Map<String, dynamic> map) {
    return DrinkCatalogModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      basePrice: map['price']?.toInt() ?? 0,
      image: map['image'] ?? '',
      iceAvailable: map['ice_available'] == 1,
      hotAvailable: map['hot_available'] == 1,
      type: map['type'] ?? '',
    );
  }

  factory DrinkCatalogModel.fromMap(Map<String, dynamic> map) {
    return DrinkCatalogModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      basePrice: map['price']?.toInt() ?? 0,
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
