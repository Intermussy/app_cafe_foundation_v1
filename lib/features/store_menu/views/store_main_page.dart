import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class StoreMainMenu extends StatefulWidget {
  const StoreMainMenu({super.key, required this.title});
  final String title;

  @override
  State<StoreMainMenu> createState() => _StoreMainMenuState();
}

class _StoreMainMenuState extends State<StoreMainMenu>
    with SingleTickerProviderStateMixin {
  late int currentPage;
  late TabController tabController;
  final List<Color> colors = [
    Colors.yellow,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.pink,
  ];

  @override
  void initState() {
    currentPage = 0;
    tabController = TabController(length: 5, vsync: this);
    tabController.animation?.addListener(() {
      final value = tabController.animation!.value.round();
      if (value != currentPage && mounted) {
        changePage(value);
      }
    });
    super.initState();
  }

  void changePage(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color unselectedColor = Colors.white;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.black,
        ),
        body: BottomBar(
          clip: Clip.none,
          fit: StackFit.expand,
          icon: (width, height) => Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: null,
              icon: Icon(
                Icons.arrow_upward_rounded,
                color: unselectedColor,
                size: width,
              ),
            ),
          ),
          borderRadius: BorderRadius.circular(500),
          duration: Duration(milliseconds: 500),
          curve: Curves.decelerate,
          showIcon: true,
          width: MediaQuery.of(context).size.width * 0.8,
          barColor: Colors.black,
          start: 2,
          end: 0,
          offset: 10,
          barAlignment: Alignment.bottomCenter,
          iconHeight: 30,
          iconWidth: 30,
          reverse: false,
          hideOnScroll: true,
          scrollOpposite: false,
          respectSafeArea: true,
          onBottomBarHidden: () {},
          onBottomBarShown: () {},
          body: (context, controller) => TabBarView(
            controller: tabController,
            dragStartBehavior: DragStartBehavior.down,
            physics: const BouncingScrollPhysics(),
            children: colors
                .map(
                  (e) => GridView.builder(
                    key: ValueKey('grid_key#${e.toString()}'),
                    controller: controller, // 👈 required for bottom bar
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // how many columns
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio:
                              1, // width/height ratio of each cell
                        ),
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: e.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Item $index',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              TabBar(
                indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                controller: tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: currentPage <= 4
                        ? colors[currentPage]
                        : unselectedColor,
                    width: 4,
                  ),
                  insets: EdgeInsets.fromLTRB(16, 0, 16, 8),
                ),
                tabs: [
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.home,
                        color: currentPage == 0 ? colors[0] : unselectedColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: currentPage == 1 ? colors[1] : unselectedColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: currentPage == 2 ? colors[2] : unselectedColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: currentPage == 3 ? colors[3] : unselectedColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 40,
                    child: Center(
                      child: Icon(
                        Icons.settings,
                        color: currentPage == 4 ? colors[4] : unselectedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
