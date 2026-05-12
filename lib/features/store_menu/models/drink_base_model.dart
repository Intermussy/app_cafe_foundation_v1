// ignore_for_file: non_constant_identifier_names

abstract class DrinkBaseModel {
  final String name;
  final int basePrice;
  final String image;
  final bool iceAvailable;
  final bool hotAvailable;
  final String type;
  DrinkBaseModel({
    required this.name,
    required this.basePrice,
    required this.image,
    required this.iceAvailable,
    required this.hotAvailable,
    required this.type,
  });
}
