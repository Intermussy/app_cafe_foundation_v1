import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/cart/cart_bloc.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_source.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemSelector extends StatelessWidget {
  const CartItemSelector({super.key, required this.itemId});
  final int itemId;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, DrinkCartModel?>(
      selector: (state) {
        if (state is! CartLoaded) {
          return null;
        }

        return state.cart.firstWhereOrNull((e) => e.id == itemId);
      },
      builder: (context, drink) {
        if (drink == null) {
          return const SizedBox.shrink();
        }
        return ItemCartWidget(
          key: ValueKey(drink.id),
          drink: drink,
          onIncrement: (val) {
            context.read<CartBloc>().add(IncrementCart(drink: val));
          },
          onDecrement: (val) {
            if (val.quantity > 1) {
              context.read<CartBloc>().add(DecrementCart(drink: val));
            } else {
              context.read<CartBloc>().add(CartAbort(item: val));
            }
          },
        );
      },
    );
  }
}

class ItemCartWidget extends StatelessWidget {
  const ItemCartWidget({
    super.key,
    required this.drink,
    required this.onIncrement,
    required this.onDecrement,
  });
  final DrinkCartModel drink;
  final ValueChanged<DrinkCartModel> onIncrement;
  final ValueChanged<DrinkCartModel> onDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(25),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drink.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        RupiahFormatter.withRupiah(drink.getTotalPrice()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              // TODO: handle edit action
                              final newDrink = await Navigator.of(context)
                                  .pushNamed<DrinkCartModel>(
                                    '/drinkdetail',
                                    arguments: (
                                      FromCart(cartDrink: drink),
                                      true,
                                    ),
                                  );
                              if (newDrink != null) {}
                            },
                            icon: const Icon(
                              Icons.edit_note_outlined,
                              size: 14,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ), // red border
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ), // pill shape
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              minimumSize: Size(0, 28),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // minus button
                              OutlinedButton(
                                onPressed: () {
                                  // TODO: decrease quantity
                                  onDecrement(drink);
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.all(4),
                                  visualDensity: VisualDensity.compact,
                                  minimumSize: const Size(28, 28),
                                ),
                                child: Icon(
                                  drink.quantity == 1
                                      ? Icons.delete_outline
                                      : Icons.remove,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),

                              // quantity text
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  drink.quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // plus button
                              OutlinedButton(
                                onPressed: () {
                                  // TODO: increase quantity
                                  // TODO:

                                  onIncrement(drink);
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.all(4),
                                  visualDensity: VisualDensity.compact,
                                  minimumSize: const Size(28, 28),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Image.network(
                  drink.image,
                  width: 120, // optional
                  fit: BoxFit.cover, // adjust how it fits inside its box
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
