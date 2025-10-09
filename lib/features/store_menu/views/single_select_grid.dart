import 'package:flutter/material.dart';

class SingleSelectGrid extends StatefulWidget {
  const SingleSelectGrid({
    super.key,
    required this.levels,

    required this.crossAxisCount,
    required this.selected,
    required this.onChanged,
    required this.label,
  });
  final String label;
  final List<String> levels;
  final String selected;
  final int crossAxisCount;
  final ValueChanged<String> onChanged;
  @override
  State<SingleSelectGrid> createState() => _SingleSelectGridState();
}

class _SingleSelectGridState extends State<SingleSelectGrid> {
  String _selected = '';

  void onSelected(String s) {
    setState(() {
      _selected = s;
    });
    widget.onChanged(s);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.selected.isNotEmpty) {
      _selected = widget.selected;
    }
  }

  @override
  void didUpdateWidget(covariant SingleSelectGrid oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.levels != widget.levels) {
      if (widget.selected.isNotEmpty) {
        _selected = widget.selected;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: 1.0,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: widget.levels.length,
            itemBuilder: (context, index) {
              final level = widget.levels[index];
              final isSelected = _selected == level;
              return GridTile(
                child: _buildSelectableTile(
                  label: level,
                  isSelected: isSelected,
                  onTap: () => onSelected(level),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSelectableTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[100] : Colors.grey[200],
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
