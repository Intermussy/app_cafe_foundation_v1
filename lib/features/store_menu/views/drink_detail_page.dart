import 'package:app_foundation/commons/widgets/custom_toast.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/cart/cart_bloc.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/drink_customization/drink_bloc.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/drink_source.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:app_foundation/features/store_menu/views/multi_select_grid.dart';
import 'package:app_foundation/features/store_menu/views/price_confirmation_widget.dart';
import 'package:app_foundation/features/store_menu/views/single_select_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<int> totalPrice = [];
  FToast fToast = FToast();
  late DrinkBloc _drinkBloc;

  late DrinkDetailModel model;
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
      _drinkBloc = DrinkBloc(initialModel: model);
      if (!model.canBeCold) {
        iceLevel = ["none"];
        tempLevel = ["hot"];
      }
      if (!model.canBeHot) {
        tempLevel = ["cold"];
      }
    } else if (src is FromMenu) {
      model = src.toDetailModel();
      _drinkBloc = DrinkBloc(initialModel: model);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _drinkBloc),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<DrinkBloc, DrinkState>(
          buildWhen: (previous, current) {
            return true;
          },
          builder: (context, state) {
            if (state is DrinkLoaded) {
              return PriceConfirmationWidget(
                totalPrice: state.getTotalPrice(),
                quantity: state.model.quantity,
                onSubmit: () {
                  context.read<DrinkBloc>().add(DrinkSubmit());
                },
                onDecrement: (s) {
                  if (state.model.quantity > 1) {
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
            }
            return SizedBox();
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
              child: BlocBuilder<DrinkBloc, DrinkState>(
                buildWhen: (previous, current) {
                  return true;
                },
                builder: (context, state) {
                  if (state is DrinkLoaded) {
                    if (state.selectedTemp == 'cold' && state.model.canBeCold) {
                      return SingleSelectGrid(
                        label: 'Ice Level',
                        levels: iceLevel,
                        crossAxisCount: 3,
                        selected: state.selectedIce,
                        onChanged: (String s) {
                          context.read<DrinkBloc>().add(
                            DrinkUpdateIceLevel(ice: s),
                          );
                        },
                      );
                    }
                  }
                  return SizedBox();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BlocConsumer<DrinkBloc, DrinkState>(
                listenWhen: (previous, current) {
                  if (previous is DrinkLoaded && current is DrinkLoaded) {
                    return previous.selectedToppings !=
                        current.selectedToppings;
                  }
                  return false;
                },
                listener: (context, state) {
                  if (state is DrinkLoaded) {
                    final t = state.selectedToppings;
                    if (t.length == 2) {
                      fToast.showToast(
                        child: CustomToast.normalToast(
                          message: 'max toppings reached',
                        ),
                      );
                    }
                  }
                },
                buildWhen: (previous, current) {
                  return false;
                },
                builder: (context, state) {
                  if (state is DrinkLoaded) {
                    return MultiSelectGrid<Topping>(
                      maxSelection: 2,
                      selected: state.model.toppings,
                      items: Topping.getMockList(),
                      onChanged: (val) {
                        _drinkBloc.add(
                          DrinkUpdateTopping(toppings: List.from(val)),
                        );
                      },
                      label: 'Topping',
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BlocConsumer<DrinkBloc, DrinkState>(
                listenWhen: (previous, current) {
                  if (previous is DrinkLoaded && current is DrinkLoaded) {
                    return previous.selectedSyrups != current.selectedSyrups;
                  }
                  return false;
                },
                listener: (context, state) {
                  if (state is DrinkLoaded) {
                    if (state.selectedSyrups.length == 2) {
                      fToast.removeQueuedCustomToasts();
                      fToast.showToast(
                        child: CustomToast.normalToast(
                          message: 'max syrups reached',
                        ),
                      );
                    } else {
                      fToast.removeCustomToast();
                      fToast.showToast(
                        child: CustomToast.normalToast(
                          message: '${state.selectedSyrups.last.name} selected',
                        ),
                      );
                    }
                  }
                },
                buildWhen: (previous, current) {
                  return false;
                },
                builder: (context, state) {
                  if (state is DrinkLoaded) {
                    return MultiSelectGrid<Syrup>(
                      maxSelection: 2,
                      selected: state.selectedSyrups,
                      items: Syrup.getMockList(),
                      onChanged: (val) {
                        _drinkBloc.add(
                          DrinkUpdateSyrup(syrups: List.from(val)),
                        );
                      },
                      label: 'Syrup',
                    );
                  }

                  return SizedBox();
                },
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
