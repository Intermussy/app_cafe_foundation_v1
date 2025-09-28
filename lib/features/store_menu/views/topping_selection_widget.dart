import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/topping_list.dart';
import 'package:flutter/material.dart';

class ToppingSelectionWidget extends StatefulWidget {
  const ToppingSelectionWidget({super.key, required this.toppings});
  final List<Topping> toppings;

  @override
  State<ToppingSelectionWidget> createState() => _ToppingSelectionWidgetState();
}

class _ToppingSelectionWidgetState extends State<ToppingSelectionWidget> {
  late List<Topping> toppings;

  Set<int> _selected = {};
  void _toggleSelection(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        if (_selected.length < 2) {
          _selected.add(index);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toppings = widget.toppings;
  }

  @override
  void didUpdateWidget(covariant ToppingSelectionWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // TODO: reload data TOPPING
    if (widget.toppings != oldWidget.toppings) toppings = widget.toppings;
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 8,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      delegate: SliverChildBuilderDelegate(childCount: toppings.length, (
        context,
        index,
      ) {
        final isSelected = _selected.contains(index);

        return GestureDetector(
          onTap: () {
            _toggleSelection(index);
          },
          child: ClipRRect(
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.red[100] : Colors.grey[200],
                border: Border.all(
                  color: isSelected ? Colors.red : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.add,
                      color: isSelected ? Colors.red : Colors.grey,
                    ),
                    Text(
                      toppings[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text(
                      RupiahFormatter.withRupiah(toppings[index].price),
                      style: TextStyle(
                        color: isSelected ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
