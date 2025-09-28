import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:flutter/material.dart';

class SyrupSelectionWidget extends StatefulWidget {
  const SyrupSelectionWidget({super.key, required this.syrups});
  final List<Syrup> syrups;

  @override
  State<SyrupSelectionWidget> createState() => _SyrupSelectionWidgetState();
}

class _SyrupSelectionWidgetState extends State<SyrupSelectionWidget> {
  late List<Syrup> syrups;

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
    syrups = widget.syrups;
  }

  @override
  void didUpdateWidget(covariant SyrupSelectionWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    // TODO: reload data SYRUP
    if (widget.syrups != oldWidget.syrups) syrups = widget.syrups;
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
      delegate: SliverChildBuilderDelegate(childCount: syrups.length, (
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
                      syrups[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text(
                      RupiahFormatter.withRupiah(syrups[index].price),
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
