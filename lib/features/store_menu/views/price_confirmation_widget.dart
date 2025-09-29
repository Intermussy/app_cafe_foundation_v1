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
  late int _quantity;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _quantity = widget.quantity;
  }

  @override
  void didUpdateWidget(covariant PriceConfirmationWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _quantity = widget.quantity;
    }
  }

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
          OutlinedButton(
            onPressed: () {
              // TODO: decrease quantity
            },
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.all(4),
              visualDensity: VisualDensity.compact,
              minimumSize: const Size(56, 56),
            ),
            child: const Icon(Icons.remove, color: Colors.red, size: 28),
          ),

          // quantity text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _quantity.toString(), // TODO: bind this to a state variable
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // plus button
          OutlinedButton(
            onPressed: () {
              // TODO: increase quantity
            },
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.all(4),
              visualDensity: VisualDensity.compact,
              minimumSize: const Size(56, 56),
            ),
            child: const Icon(Icons.add, color: Colors.red, size: 28),
          ),
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
