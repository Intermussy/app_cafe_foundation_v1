import 'package:app_foundation/bindings/app_logger.dart';
import 'package:app_foundation/commons/widgets/custom_toast.dart';
import 'package:app_foundation/commons/widgets/skeletons.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/cart/cart_bloc.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/drink_customization/drink_bloc.dart';
import 'package:app_foundation/features/store_menu/models/drink_detail_model.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_mapper.dart';
import 'package:app_foundation/features/store_menu/models/adapters/drink_source.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:app_foundation/features/store_menu/views/drink_customization/multi_select_grid.dart';
import 'package:app_foundation/features/store_menu/views/drink_customization/price_confirmation_widget.dart';
import 'package:app_foundation/features/store_menu/views/drink_customization/single_select_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      AppLogger().debug(model.toString());
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
      AppLogger().debug(model.toString());

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
        bottomNavigationBar: BlocConsumer<DrinkBloc, DrinkState>(
          listener: (context, state) {
            if (state is DrinkSuccess) {
              fToast.showToast(
                child: CustomToast.successToast(message: 'Added to Cart'),
              );
              Navigator.of(context).pop(state.newDrink);
            } else if (state is DrinkError) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(state.error)],
                  ),
                ),
              );
            }
          },
          buildWhen: (previous, current) {
            if (current is DrinkLoading) return true;
            return current is DrinkLoaded;
          },
          builder: (context, state) {
            if (state is DrinkLoading) {
              return SkeletonWidget.regulerLoading;
            } else if (state is DrinkLoaded) {
              return PriceConfirmationWidget(
                totalPrice: state.getTotalPrice(),
                quantity: state.model.quantity,
                onSubmit: () {
                  _drinkBloc.add(DrinkSubmit());
                },
                onDecrement: (s) {
                  if (state.model.quantity > 1) {
                    _drinkBloc.add(DrinkDecrementQuantity(changes: s));
                  }
                },
                onIncrement: (s) {
                  _drinkBloc.add(DrinkIncrementQuantity(changes: s));
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
                    background: Image.network(model.image, fit: BoxFit.cover),
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
                      _drinkBloc.add(DrinkUpdateTempLevel(temperature: s));
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
                      _drinkBloc.add(DrinkUpdateSugarLevel(sugar: s));
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
                          _drinkBloc.add(DrinkUpdateIceLevel(ice: s));
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
                  if (previous is DrinkLoaded && current is DrinkLoaded) {
                    return previous.isAddonLoading != current.isAddonLoading;
                  }
                  return true;
                },
                builder: (context, state) {
                  if (state is DrinkLoaded) {
                    if (state.isAddonLoading) {
                      return Skeleton.shade(
                        child: MultiSelectGrid<Topping>(
                          maxSelection: 2,
                          selected: const [],
                          items: const [], // temporarily empty
                          onChanged: (_) {},
                          label: 'Topping',
                        ),
                      );
                    } else {
                      return MultiSelectGrid<Topping>(
                        maxSelection: 2,
                        selected: state.model.toppings,
                        items: state.availableToppings,
                        onChanged: (val) {
                          _drinkBloc.add(
                            DrinkUpdateTopping(toppings: List.from(val)),
                          );
                        },
                        label: 'Topping',
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
                  if (current is DrinkLoaded && previous is DrinkLoaded) {
                    return previous.isAddonLoading != current.isAddonLoading;
                  }
                  return false;
                },
                builder: (context, state) {
                  if (state is DrinkLoaded) {
                    if (state.isAddonLoading) {
                      return Skeleton.leaf(
                        child: MultiSelectGrid<Syrup>(
                          maxSelection: 2,
                          selected: [],
                          items: [],
                          onChanged: (_) {},
                          label: 'Syrup',
                        ),
                      );
                    }
                    return MultiSelectGrid<Syrup>(
                      maxSelection: 2,
                      selected: state.selectedSyrups,
                      items: state.availableSyrups,
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
