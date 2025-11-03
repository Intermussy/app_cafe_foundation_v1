import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:flutter/material.dart';

class ReceiptItemWidget extends StatelessWidget {
  const ReceiptItemWidget({super.key, required this.item});
  final DrinkCartModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(thickness: 1, color: Colors.grey[200]),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [Text(item.name), Text(item.tempLevel)]),
            Text(RupiahFormatter.withRupiah(item.getTotalPrice())),
          ],
        ),
      ],
    );
  }
}
