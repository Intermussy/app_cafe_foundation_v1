import 'package:app_foundation/commons/widgets/custom_toast.dart';
import 'package:app_foundation/features/store_menu/controllers/bloc/menu/menu_bloc.dart';
import 'package:app_foundation/features/store_menu/models/drink_catalog_model.dart';
import 'package:app_foundation/features/store_menu/views/catalog/auto_scroll_carousel.dart';
import 'package:app_foundation/features/store_menu/views/catalog/item_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StoreMainMenu extends StatefulWidget {
  const StoreMainMenu({super.key});

  @override
  State<StoreMainMenu> createState() => _StoreMainMenuState();
}

class _StoreMainMenuState extends State<StoreMainMenu>
    with SingleTickerProviderStateMixin {
  final _menuBloc = MenuBloc();
  var mockDrinkMenuView = DrinkCatalogModel.getMockList();
  FToast ftoast = FToast();
  late TabController tabController;
  final List<String> tabs = ["All", "Coffee", "Non-coffee"];
  DateTime? lastPressed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    ftoast.init(context);
    _menuBloc.add(LoadMenuEvent());
  }

  @override
  void didUpdateWidget(covariant StoreMainMenu oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _menuBloc.add(LoadMenuEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    ftoast.removeQueuedCustomToasts();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final now = DateTime.now();

        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          //TODO: show an alert message 'Press again to exit
          ftoast.showToast(
            child: CustomToast.normalToast(message: 'Press again to exit app'),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: BlocProvider(
        create: (context) => _menuBloc,
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => _menuBloc.add(LoadMenuEvent()),
            child: CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 2,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BlocListener<MenuBloc, MenuState>(
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onChanged: (value) =>
                                _menuBloc.add(MenuSeachEvent(query: value)),
                            decoration: InputDecoration(
                              hintText: "Search Drinks...",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/shoppingcart');
                            },
                            icon: Icon(Icons.shopping_cart),
                          ),
                          BlocSelector<MenuBloc, MenuState, String>(
                            selector: (state) {
                              return state is MenuLoaded
                                  ? state.cartCount.toString()
                                  : '';
                            },
                            builder: (context, count) {
                              if (count == "" || count == "0")
                                return Container();
                              return Positioned(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minHeight: 16,
                                    minWidth: 16,
                                  ),
                                  child: Text(
                                    count,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: AutoScrollCarousel(),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _sliverTabBarDelegateTab(
                    tabBar: TabBar(
                      controller: tabController,
                      onTap: (value) {
                        switch (value) {
                          case 1:
                            _menuBloc.add(MenuFilterTypeEvent(type: 'coffee'));
                            break;
                          case 2:
                            _menuBloc.add(
                              MenuFilterTypeEvent(type: 'non-coffee'),
                            );
                          default:
                            _menuBloc.add(MenuFilterTypeEvent(type: 'all'));
                        }
                      },
                      indicatorColor: Colors.red,
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.grey,
                      tabs: tabs.map((t) => Tab(text: t)).toList(),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverToBoxAdapter(
                    child: BlocConsumer<MenuBloc, MenuState>(
                      listener: (context, current) {},
                      buildWhen: (previous, current) {
                        if (previous is MenuLoaded && current is MenuLoaded) {
                          return previous.filteredDrinks !=
                              current.filteredDrinks;
                        }
                        return true;
                      },
                      builder: (context, state) {
                        switch (state) {
                          case MenuLoaded _:
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: state.filteredDrinks.length,
                              itemBuilder: (context, index) => ItemMenuWidget(
                                drink: state.filteredDrinks[index],
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.8,
                                  ),
                            );

                          default:
                            return Skeletonizer(
                              enabled: state is MenuLoading,
                              effect: PulseEffect(),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 10,
                                itemBuilder: (_, _) => Bone.square(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 0.8,
                                    ),
                              ),
                            );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _sliverTabBarDelegateTab extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _sliverTabBarDelegateTab({required this.tabBar});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // TODO: implement build
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => tabBar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
