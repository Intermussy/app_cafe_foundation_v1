import 'package:app_foundation/bindings/app_logger.dart';
import 'package:app_foundation/bindings/rupiah_formatter.dart';
import 'package:app_foundation/features/store_menu/models/drink_catalog_model.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_source.dart';
import 'package:flutter/material.dart';

class ItemMenuWidget extends StatelessWidget {
  const ItemMenuWidget({super.key, required this.drink});
  final DrinkCatalogModel drink;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,

      color: Colors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: () {
          AppLogger().info(drink.toMap().toString());
          Navigator.of(context).pushNamed(
            '/drinkdetail',
            arguments: (FromMenu(menuDrink: drink), false),
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                drink.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    RupiahFormatter.withRupiah(drink.basePrice),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                children: [
                  Icon(
                    Icons.ac_unit,
                    size: 24,
                    color: drink.iceAvailable ? Colors.blue : Colors.grey,
                  ),
                  Icon(
                    Icons.local_fire_department,
                    size: 24,
                    color: drink.hotAvailable ? Colors.red : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
