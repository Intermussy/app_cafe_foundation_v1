import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:flutter/material.dart';

class PriceConfirmationWidget extends StatefulWidget {
  const PriceConfirmationWidget({
    super.key,
    required this.totalPrice,
    required this.quantity,
    required this.onSubmit,
    required this.onDecrement,
    required this.onIncrement,
  });
  final int quantity;
  final int totalPrice;
  final VoidCallback onSubmit;
  final ValueChanged<int> onDecrement;
  final ValueChanged<int> onIncrement;

  @override
  State<PriceConfirmationWidget> createState() =>
      _PriceConfirmationWidgetState();
}

class _PriceConfirmationWidgetState extends State<PriceConfirmationWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                  widget.onDecrement(1);
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
                  widget.quantity
                      .toString(), // TODO: bind this to a state variable
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              // plus button
              OutlinedButton(
                onPressed: () {
                  // TODO: increase quantity
                  widget.onIncrement(1);
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
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: widget.onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "+ Cart ${RupiahFormatter.withRupiah(widget.totalPrice)}",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontSize: constraints.maxWidth > 320 ? 16 : 9,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
