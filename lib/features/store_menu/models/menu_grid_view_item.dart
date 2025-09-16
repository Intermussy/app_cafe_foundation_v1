import 'package:app_foundation/features/store_menu/models/ice_level.dart';
import 'package:app_foundation/features/store_menu/models/sugar_level.dart';

class Menugridviewitem {
  final String itemName;
  final int price;
  final bool iceAvailable;
  final bool hotAvailable;
  final bool regularSizeAvailable;
  final bool largeSizeAvailable;
  final SugarLevel sugarLevel;
  final IceLevel iceLevel;
  Menugridviewitem({
    required this.itemName,
    required this.price,
    required this.iceAvailable,
    required this.hotAvailable,
    required this.regularSizeAvailable,
    required this.largeSizeAvailable,
    required this.sugarLevel,
    required this.iceLevel,
  });
}
