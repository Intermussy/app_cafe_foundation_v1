import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:flutter/material.dart';

class ReceiptItemWidget extends StatefulWidget {
  const ReceiptItemWidget({super.key, required this.item});
  final DrinkCartModel item;

  @override
  State<ReceiptItemWidget> createState() => _ReceiptItemWidgetState();
}

class _ReceiptItemWidgetState extends State<ReceiptItemWidget> {
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
            Column(
              children: [Text(widget.item.name), Text(widget.item.tempLevel)],
            ),
            Text(RupiahFormatter.withRupiah(widget.item.price)),
          ],
        ),
      ],
    );
  }
}
