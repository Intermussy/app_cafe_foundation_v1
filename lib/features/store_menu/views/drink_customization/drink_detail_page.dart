import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_source.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:app_foundation/features/store_menu/views/drink_customization/multi_select_grid.dart';
import 'package:app_foundation/features/store_menu/views/drink_customization/price_confirmation_widget.dart';
import 'package:app_foundation/features/store_menu/views/drink_customization/single_select_grid.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class DrinkDetailPage extends StatefulWidget {
  const DrinkDetailPage({
    super.key,
    required this.source,
    required this.isEdit,
  });
  final DrinkSource source;
  final bool isEdit;
  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  List<String> sugarLevel = ["normal", "less", "none"];
  List<String> iceLevel = ["normal", "less", "none"];
  List<String> tempLevel = ["hot", "cold"];
  FToast fToast = FToast();
  late int quantity;
  late DrinkDetailModel model;

  String selectedTemp = '';

  String selectedSugar = '';

  String selectedIce = '';

  List<Topping> selectedToppings = [];

  List<Syrup> selectedSyrup = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUpdateDrinkPage();
    if (!mounted) return;
    fToast.init(context);
  }

  void initUpdateDrinkPage() {
    final src = widget.source;

    if (src is FromCart) {
      model = src.toDetailModel();
      quantity = model.quantity;
      if (!model.canBeCold) {
        iceLevel = ["none"];
        tempLevel = ["hot"];
      }
      if (!model.canBeHot) {
        tempLevel = ["cold"];
      }
    } else if (src is FromMenu) {
      model = src.toDetailModel();
      quantity = model.quantity;

      if (!model.canBeCold) {
        iceLevel = ["none"];
        tempLevel = ["hot"];
      }
      if (!model.canBeHot) {
        tempLevel = ["cold"];
      }
    } else {
      throw AssertionError('Unhandled DrinkSource: $src');
    }
  }

  @override
  void didUpdateWidget(covariant DrinkDetailPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      initUpdateDrinkPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PriceConfirmationWidget(
        totalPrice: getTotalPrice(),
        quantity: quantity,
        onSubmit: () {
          Navigator.of(context).pop();
        },
        onDecrement: (s) {
          if (quantity > 1) {
            setState(() => quantity = quantity - 1);
          }
        },
        onIncrement: (s) {
          setState(() => quantity = quantity + 1);
        },
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
                    model.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      shadows: isCollapsed
                          ? []
                          : [Shadow(blurRadius: 4, color: Colors.black)],
                      color: isCollapsed ? Colors.black : Colors.white,
                    ),
                  ),
                  centerTitle: false,
                  collapseMode: CollapseMode.parallax,
                  background: Image.asset(model.image, fit: BoxFit.cover),
                );
              },
            ),
          ),
          SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 16)),
          SliverToBoxAdapter(
            child: SingleSelectGrid(
              label: 'Temperature',
              levels: tempLevel,
              crossAxisCount: 2,
              selected: selectedTemp,
              onChanged: (String s) {},
            ),
          ),
          SliverToBoxAdapter(
            child: SingleSelectGrid(
              label: 'Sugar level',
              levels: sugarLevel,
              crossAxisCount: 3,
              selected: selectedSugar,
              onChanged: (s) {},
            ),
          ),

          SliverToBoxAdapter(
            child: SingleSelectGrid(
              label: 'Ice Level',
              levels: iceLevel,
              crossAxisCount: 3,
              selected: selectedIce,
              onChanged: (String s) {},
            ),
          ),

          SliverToBoxAdapter(
            child: MultiSelectGrid<Topping>(
              maxSelection: 2,
              selected: selectedToppings,
              items: Topping.getMockList(),
              onChanged: (val) {
                setState(() {
                  selectedToppings = val;
                });
              },
              label: 'Topping',
            ),
          ),
          SliverToBoxAdapter(
            child: MultiSelectGrid<Syrup>(
              maxSelection: 2,
              selected: selectedSyrup,
              items: Syrup.getMockList(),
              onChanged: (val) {
                setState(() {
                  selectedSyrup = val;
                });
              },
              label: 'Syrup',
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  int getTotalPrice() {
    return (model.basePrice +
            selectedToppings.fold<int>(0, (start, t) => start + t.price) +
            selectedSyrup.fold<int>(0, (start, s) => start + s.price)) *
        quantity;
  }
}
