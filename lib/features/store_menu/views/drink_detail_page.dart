import 'package:app_foundation/features/store_menu/controllers/bloc/cart/cart_bloc.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/drink_customization/drink_bloc.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/drink_source.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:app_foundation/features/store_menu/views/multi_select_grid.dart';
import 'package:app_foundation/features/store_menu/views/price_confirmation_widget.dart';
import 'package:app_foundation/features/store_menu/views/single_select_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  List<int> totalPrice = [];

  late DrinkDetailModel model;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUpdateDrinkPage();
  }

  void initUpdateDrinkPage() {
    final src = widget.source;

    if (src is FromCart) {
      model = src.toDetailModel();
      if (!model.canBeCold) {
        iceLevel = ["none"];
        tempLevel = ["hot"];
      }
    } else if (src is FromMenu) {
      model = src.toDetailModel();
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

  ValueListenable<List<Topping>> listenableTopping = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DrinkBloc(initialModel: model)),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: Scaffold(
        bottomNavigationBar:
            BlocSelector<DrinkBloc, DrinkState, DrinkDetailModel>(
              selector: (state) {
                return state is DrinkLoaded ? state.model : model;
              },
              builder: (context, drink) {
                return PriceConfirmationWidget(
                  totalPrice: drink.getTotalPrice(),
                  quantity: drink.quantity,
                  onSubmit: () {
                    context.read<DrinkBloc>().add(DrinkSubmit());
                  },
                  onDecrement: (s) {
                    if (drink.quantity > 1) {
                      context.read<DrinkBloc>().add(
                        DrinkDecrementQuantity(changes: s),
                      );
                    }
                  },
                  onIncrement: (s) {
                    context.read<DrinkBloc>().add(
                      DrinkIncrementQuantity(changes: s),
                    );
                  },
                );
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
              child: BlocSelector<DrinkBloc, DrinkState, String>(
                selector: (state) =>
                    state is DrinkLoaded ? state.selectedTemp : 'none',
                builder: (context, selectedTemp) {
                  return SingleSelectGrid(
                    label: 'Temperature',
                    levels: tempLevel,
                    crossAxisCount: 2,
                    selected: selectedTemp,
                    onChanged: (String s) {
                      context.read<DrinkBloc>().add(
                        DrinkUpdateTempLevel(temperature: s),
                      );
                    },
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BlocSelector<DrinkBloc, DrinkState, String>(
                selector: (state) {
                  return state is DrinkLoaded ? state.selectedSugar : 'normal';
                },
                builder: (context, sugar) {
                  return SingleSelectGrid(
                    label: 'Sugar level',
                    levels: sugarLevel,
                    crossAxisCount: 3,
                    selected: sugar,
                    onChanged: (s) {
                      context.read<DrinkBloc>().add(
                        DrinkUpdateSugarLevel(sugar: s),
                      );
                    },
                  );
                },
              ),
            ),

            SliverToBoxAdapter(
              child: BlocSelector<DrinkBloc, DrinkState, String>(
                selector: (state) {
                  return state is DrinkLoaded ? state.selectedIce : 'none';
                },
                builder: (context, ice) {
                  if (ice == 'cold' && model.canBeCold) {
                    return SingleSelectGrid(
                      label: 'Ice Level',
                      levels: iceLevel,
                      crossAxisCount: 3,
                      selected: ice,
                      onChanged: (String s) {
                        context.read<DrinkBloc>().add(
                          DrinkUpdateIceLevel(ice: s),
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BlocListener<DrinkBloc, DrinkState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is DrinkLoaded) {
                    if (state.selectedToppings.length == 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('maximum toppings exceeded')),
                      );
                    }
                  }
                },
                child: BlocSelector<DrinkBloc, DrinkState, List<Topping>>(
                  selector: (state) {
                    return state is DrinkLoaded ? state.selectedToppings : [];
                  },
                  builder: (context, toppings) {
                    return MultiSelectGrid<Topping>(
                      maxSelection: 2,
                      selected: (toppings),
                      items: Topping.getMockList(),
                      onChanged: (val) {
                        if (model.toppings.length < 3) {
                          context.read<DrinkBloc>().add(
                            DrinkUpdateTopping(toppings: val),
                          );
                        }
                      },
                      label: 'Topping',
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocListener<DrinkBloc, DrinkState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is DrinkLoaded) {
                    if (state.selectedSyrups.length == 2) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('maximum syrups exceeded')),
                      );
                    }
                  }
                },
                child: BlocSelector<DrinkBloc, DrinkState, List<Syrup>>(
                  selector: (state) {
                    return state is DrinkLoaded ? state.selectedSyrups : [];
                  },
                  builder: (context, syrups) {
                    return MultiSelectGrid<Syrup>(
                      maxSelection: 2,
                      selected: syrups,
                      items: Syrup.getMockList(),
                      onChanged: (val) {
                        if (model.syrups.length < 3) {
                          context.read<DrinkBloc>().add(
                            DrinkUpdateSyrup(syrups: val),
                          );
                        }
                      },
                      label: 'Syrup',
                    );
                  },
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
