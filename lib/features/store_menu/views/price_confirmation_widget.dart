import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:flutter/material.dart';

class PriceConfirmationWidget extends StatefulWidget {
  const PriceConfirmationWidget({
    super.key,
    required this.totalPrice,
    required this.quantity,
  });
  final int quantity;
  final int totalPrice;

  @override
  State<PriceConfirmationWidget> createState() =>
      _PriceConfirmationWidgetState();
}

class _PriceConfirmationWidgetState extends State<PriceConfirmationWidget> {
  @override
  Widget build(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              // handle add to cart
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "+ Cart ${RupiahFormatter.withRupiah(widget.totalPrice)}",
              // style: Theme.of(context).textTheme.titleLarge!.copyWith(
              //   color: Colors.red,
              //   fontWeight: FontWeight.bold,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
