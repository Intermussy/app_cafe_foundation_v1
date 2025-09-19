import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping_list.dart';

class CartItemView {
  final String name;
  final int price;
  final int quantity;
  final List<Topping>? toppingList;
  final List<Syrup>? syrupList;
  CartItemView({
    required this.name,
    required this.price,
    required this.quantity,
    this.toppingList,
    this.syrupList,
  });

  int getTotalPrice() {
    final toppingsTotal = (toppingList ?? []).fold<int>(
      0,
      (sum, t) => sum + t.price,
    );

    final syrupsTotal = (syrupList ?? []).fold<int>(
      0,
      (sum, s) => sum + s.price,
    );

    // toppings/syrups apply PER drink
    return (quantity * (price + toppingsTotal + syrupsTotal));
  }

  String getAllSyrupDesc() {
    if (syrupList == null || syrupList!.isEmpty) return "";

    return syrupList!.map((t) => t.name).join(", ");
  }

  String getAllToppingDesc() {
    if (toppingList == null || toppingList!.isEmpty) return "";

    return toppingList!.map((t) => t.name).join(", ");
  }

  CartItemView copyWith({
    String? name,
    int? price,
    int? quantity,
    List<Topping>? toppingList,
    List<Syrup>? syrupList,
  }) {
    return CartItemView(
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      toppingList: toppingList ?? this.toppingList,
      syrupList: syrupList ?? this.syrupList,
    );
  }

  @override
  String toString() {
    return 'CartListItemView(itemName: $name, price: $price, quantity: $quantity, toppingList: $toppingList, syrupList: $syrupList)';
  }

  static CartItemView getMockData() {
    return CartItemView(
      name: "Americano",
      price: 15000,
      quantity: 2,
      toppingList: List.filled(1, Topping.getMockData()),
    );
  }

  static List<CartItemView> getMockList() {
    return [
      CartItemView(
        name: "Americano",
        price: 15000,
        quantity: 1,
        toppingList: Topping.getMockList().toList(),
      ),
      CartItemView(name: "Babycchino", price: 20000, quantity: 1),
      CartItemView(name: "Avocado", price: 24000, quantity: 1),
    ];
  }
}
