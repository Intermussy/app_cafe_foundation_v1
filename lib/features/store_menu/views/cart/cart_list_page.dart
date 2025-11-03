import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/views/cart/item_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({super.key});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  FToast fToast = FToast();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!mounted) return;
    fToast.init(context);
  }

  @override
  void didUpdateWidget(covariant CartListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    fToast.removeQueuedCustomToasts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            child: Center(
              child: Text(
                RupiahFormatter.withRupiah(
                  DrinkCartModel.getMockList().getTotalPrice(),
                ),
              ),
            ),
          ),

          Container(
            height: 75,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/orderreceipt',
                  arguments: DrinkCartModel.getMockList(),
                );
              },
              child: Center(
                child: Text(
                  'CONFIRM ORDER',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(title: Text('Cart List')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => (),
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: DrinkCartModel.getMockList().length,
            itemBuilder: (context, index) {
              final drink = DrinkCartModel.getMockList()[index];
              return ItemCartWidget(
                drink: drink,
                onQuantityChanged: (DrinkCartModel val) {},
              );
            },
          ),
        ),
      ),
    );
  }
}
