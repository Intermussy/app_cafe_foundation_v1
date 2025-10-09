import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ItemCartWidget extends StatefulWidget {
  const ItemCartWidget({
    super.key,
    required this.cartDrinks,
    required this.notifyChanges,
  });
  final List<DrinkCartModel> cartDrinks;
  final VoidCallback notifyChanges;
  @override
  State<ItemCartWidget> createState() => _ItemCartWidgetState();
}

class _ItemCartWidgetState extends State<ItemCartWidget> {
  late List<DrinkCartModel> _cartDrinks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartDrinks = widget.cartDrinks;
  }

  void onChanged() {
    widget.notifyChanges();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cartDrinks.isEmpty) {
      return Center(child: Text('Kosong... seperti hidup gua...'));
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        physics: BouncingScrollPhysics(),
        itemCount: _cartDrinks.length,
        itemBuilder: (context, index) {
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
                              _cartDrinks[index].name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              RupiahFormatter.withRupiah(
                                _cartDrinks[index].getTotalPrice(),
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // TODO: handle edit action
                                    Navigator.of(
                                      context,
                                    ).pushNamed<DrinkCartModel>(
                                      '/drinkdetail',
                                      arguments: (
                                        FromCart(cartDrink: _cartDrinks[index]),
                                        true,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_note_outlined,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                  label: const Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
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
                                        if (_cartDrinks[index].quantity > 1) {
                                          setState(() {
                                            _cartDrinks[index] =
                                                _cartDrinks[index].copyWith(
                                                  quantity:
                                                      (_cartDrinks[index]
                                                          .quantity -
                                                      1),
                                                );
                                          });
                                          onChanged();
                                        } else {
                                          //TODO: press again to remove?
                                        }
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        visualDensity: VisualDensity.compact,
                                        minimumSize: const Size(28, 28),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        color: Colors.red,
                                        size: 14,
                                      ),
                                    ),

                                    // quantity text
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        _cartDrinks[index].quantity.toString(),
                                        // TODO: bind this to a state variable
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
                                        setState(() {
                                          _cartDrinks[index] =
                                              _cartDrinks[index].copyWith(
                                                quantity:
                                                    (_cartDrinks[index]
                                                        .quantity +
                                                    1),
                                              );
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
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

                      Image.asset(
                        _cartDrinks[index].image,
                        width: 120, // optional
                        fit: BoxFit.cover, // adjust how it fits inside its box
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      IterableProperty<DrinkCartModel>('_cartDrinks', _cartDrinks),
    );
  }
}
