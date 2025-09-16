import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping_list.dart';

class CartListItemView {
  final String itemName;
  final int price;
  final int quantity;
  final List<Topping>? toppingList;
  final List<Syrup>? syrupList;
  CartListItemView({
    required this.itemName,
    required this.price,
    required this.quantity,
    this.toppingList,
    this.syrupList,
  });

  int getTotalPrice() {
    int total = price;
    if (toppingList!.isNotEmpty) {
      for (Topping topping in toppingList!) {
        total += topping.priceTopping;
      }
    }
    if (syrupList!.isNotEmpty) {
      for (Syrup syrup in syrupList!) {
        total += syrup.price;
      }
    }

    return total;
  }

  String getAllSyrup() {
    StringBuffer syrupDesc = StringBuffer("");

    if (syrupList!.isNotEmpty) {
      for (Syrup syrup in syrupList!) {
        syrupDesc.write("${syrup.nameSyrup}, ");
      }
    }
    return syrupDesc.toString();
  }

  String getAllTopping() {
    StringBuffer toppingDesc = StringBuffer("");

    if (toppingList!.isNotEmpty) {
      for (Topping topping in toppingList!) {
        toppingDesc.write("${topping.nameTopping}, ");
      }
    }
    return toppingDesc.toString();
  }
}
