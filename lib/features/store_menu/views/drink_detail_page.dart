import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping_list.dart';
import 'package:app_foundation/features/store_menu/views/price_confirmation_widget.dart';
import 'package:app_foundation/features/store_menu/views/syrup_selection_widget.dart';
import 'package:app_foundation/features/store_menu/views/topping_selection_widget.dart';
import 'package:flutter/material.dart';

class DrinkDetailPage extends StatefulWidget {
  const DrinkDetailPage({super.key});

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  int? _selectedTemp;
  List<String> sugarLevel = ["Normal", "Less", "None"];
  List<String> iceLevel = ["Normal", "Less", "None"];
  List<String> tempLevel = ["Hot", "Cold"];
  List<Topping>? _selectedTopping;
  List<Syrup>? _selectedSyrup;
  List<int> totalPrice = [];
  int? _selectedSugar;

  int? _selectedIce;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PriceConfirmationWidget(
        totalPrice: 20000,
        quantity: 1,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.amber,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                // SliverAppBar expanded range
                final double maxHeight = constraints.biggest.height;
                // Threshold: when collapsed height is reached, we remove the shadow
                final bool isCollapsed =
                    maxHeight <=
                    kToolbarHeight + MediaQuery.of(context).padding.top + 10;

                return FlexibleSpaceBar(
                  title: Text(
                    'Americano',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      shadows: isCollapsed
                          ? []
                          : [Shadow(blurRadius: 4, color: Colors.black)],
                      color: isCollapsed ? Colors.black : Colors.white,
                    ),
                  ),
                  centerTitle: false,
                  collapseMode: CollapseMode.parallax,
                  background: Image.asset(
                    "assets/images/placeholder.png",
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Temp Level',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: tempLevel.length,
                (context, index) {
                  final isSelected = _selectedTemp == index;
                  return GridTile(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTemp = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.red[100]
                              : Colors.grey[200],
                          border: Border.all(
                            color: isSelected ? Colors.red : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            tempLevel[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sugar Level',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: sugarLevel.length,
                (context, index) {
                  final isSelected = _selectedSugar == index;
                  return GridTile(
                    child: _buildSelectableTile(
                      label: sugarLevel[index],
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedSugar = index),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Ice Level',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: iceLevel.length,
                (context, index) {
                  final isSelected = _selectedIce == index;
                  return GridTile(
                    child: _buildSelectableTile(
                      label: iceLevel[index],
                      isSelected: isSelected,
                      onTap: () => setState(() => _selectedIce = index),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topping',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '(max 2)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: ToppingSelectionWidget(toppings: Topping.getMockList()),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Syrup', style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    '(max 2)',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SyrupSelectionWidget(syrups: Syrup.getMockList()),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
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
