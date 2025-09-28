import 'package:flutter/material.dart';

class ItemMenuWidget extends StatelessWidget {
  const ItemMenuWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Expanded(flex: 1, child: Text("Drink $index")),
            ],
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/drinkdetail');
              },
            ),
          ),
        ],
      ),
    );
  }
}
