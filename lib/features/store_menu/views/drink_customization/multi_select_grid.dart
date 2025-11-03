import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/adapters/addon_base.dart';
import 'package:flutter/material.dart';

class MultiSelectGrid<T extends AddonBase> extends StatefulWidget {
  const MultiSelectGrid({
    super.key,
    required this.maxSelection,
    required this.items,
    required this.onChanged,
    required this.label,
    required this.selected,
  });
  final String label;
  final int maxSelection;
  final List<T> items;
  final List<T> selected;

  final ValueChanged<List<T>> onChanged;
  @override
  State<MultiSelectGrid<T>> createState() => _MultiSelectGridState<T>();
}

class _MultiSelectGridState<T extends AddonBase>
    extends State<MultiSelectGrid<T>> {
  var _selected = <T>[];

  void _toggleSelection(T item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else if (_selected.length < widget.maxSelection) {
        _selected.add(item);
      }
    });
    widget.onChanged(List.unmodifiable(_selected));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.selected.isNotEmpty) {
      _selected = List<T>.of(widget.selected);
    }
  }

  @override
  void didUpdateWidget(covariant MultiSelectGrid<T> oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _selected = List<T>.from(widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label, style: Theme.of(context).textTheme.titleLarge),
              Text(
                '(max ${widget.maxSelection})',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 1.5,
              mainAxisSpacing: 12,
              childAspectRatio: 8,
            ),
            itemBuilder: (context, index) {
              final item = widget.items[index];
              bool isSelected = _selected.contains(item);
              return GestureDetector(
                onTap: () => _toggleSelection(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 188),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red[100] : Colors.grey[200],
                    border: Border.all(
                      color: isSelected ? Colors.red : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),

                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.3),
                              blurRadius: 0.6,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add,
                        color: isSelected ? Colors.red : Colors.grey,
                      ),
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: isSelected ? Colors.red : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          RupiahFormatter.withRupiah(item.price),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: isSelected ? Colors.red : Colors.grey,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
