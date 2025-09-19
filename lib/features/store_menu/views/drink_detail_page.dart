import 'package:app_foundation/features/store_menu/models/topping_list.dart';
import 'package:app_foundation/features/store_menu/views/price_confirmation_widget.dart';
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
  List<Topping> listTopping = Topping.getMockList();

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
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Americano',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              background: Image.asset(
                "assets/images/placeholder.png",
                fit: BoxFit.cover,
              ),
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
