import 'package:equatable/equatable.dart';

abstract class AddonBase extends Equatable {
  final int id;
  final String name;
  final int price;
  const AddonBase({required this.id, required this.name, required this.price});

  Map<String, dynamic> toMap();
}
