import 'package:flutter/material.dart';

class ItemCartWidget extends StatefulWidget {
  const ItemCartWidget({super.key});

  @override
  State<ItemCartWidget> createState() => _ItemCartWidgetState();
}

class _ItemCartWidgetState extends State<ItemCartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(25),
        child: InkWell(
          onTap: () {},
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Americano',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'less ice, vanilla syrup',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              // TODO: handle edit action
                            },
                            icon: const Icon(
                              Icons.edit_note_outlined,
                              size: 14,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ), // red border
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  50,
                                ), // pill shape
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              minimumSize: Size(0, 28),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // minus button
                              OutlinedButton(
                                onPressed: () {
                                  // TODO: decrease quantity
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.all(4),
                                  visualDensity: VisualDensity.compact,
                                  minimumSize: const Size(28, 28),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),

                              // quantity text
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  '1', // TODO: bind this to a state variable
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                  minimumSize: const Size(28, 28),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Image.asset(
                  'assets/images/placeholder.png',
                  width: 120, // optional
                  fit: BoxFit.cover, // adjust how it fits inside its box
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
