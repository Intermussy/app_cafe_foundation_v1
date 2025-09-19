import 'package:app_foundation/features/store_menu/views/item_cart_widget.dart';
import 'package:flutter/material.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({super.key});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart List')),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ItemCartWidget(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
