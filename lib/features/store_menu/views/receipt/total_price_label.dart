import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:flutter/material.dart';

class TotalPriceLabel extends StatefulWidget {
  const TotalPriceLabel({super.key, required this.total});
  final int total;
  @override
  State<TotalPriceLabel> createState() => _TotalPriceLabelState();
}

class _TotalPriceLabelState extends State<TotalPriceLabel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(thickness: 5, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('total: '),
            Text(RupiahFormatter.withRupiah(widget.total)),
          ],
        ),
      ],
    );
  }
}
