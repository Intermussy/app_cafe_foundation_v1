import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/views/receipt/receipt_item_widget.dart';
import 'package:app_foundation/features/store_menu/views/receipt/total_price_label.dart';
import 'package:flutter/material.dart';

class OrderReceiptPage extends StatelessWidget {
  const OrderReceiptPage({super.key, required this.drinks});
  final List<DrinkCartModel> drinks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      bottomNavigationBar: orderReceiptBottomNav(context),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Order Receipt',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium!.copyWith(color: Colors.black),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 2,
                          spreadRadius: 0.2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Flexible(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: drinks.length,
                              itemBuilder: (context, index) {
                                final drink = drinks[index];
                                return ReceiptItemWidget(item: drink);
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TotalPriceLabel(
                              total: drinks.getTotalPrice(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Container orderReceiptBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: Text('Cancel'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: Text('Confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
