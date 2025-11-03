import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_catalog_model.dart';

sealed class DrinkSource {}

class FromCart extends DrinkSource {
  final DrinkCartModel cartDrink;
  FromCart({required this.cartDrink});
}

class FromMenu extends DrinkSource {
  final DrinkCatalogModel menuDrink;
  FromMenu({required this.menuDrink});
}
