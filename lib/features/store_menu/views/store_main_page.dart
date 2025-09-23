import 'package:app_foundation/features/store_menu/views/auto_scroll_carousel.dart';
import 'package:flutter/material.dart';

class StoreMainMenu extends StatefulWidget {
  const StoreMainMenu({super.key});

  @override
  State<StoreMainMenu> createState() => _StoreMainMenuState();
}

class _StoreMainMenuState extends State<StoreMainMenu>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<String> tabs = ["All", "Coffee", "Non-coffee"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 2,
            title: TextField(
              decoration: InputDecoration(
                hintText: "Search Drinks...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 26),
              ),
            ),
          ),
          SliverToBoxAdapter(child: AutoScrollCarousel()),
          SliverPersistentHeader(
            delegate: _sliverTabBarDelegateTab(
              tabBar: TabBar(
                controller: tabController,
                indicatorColor: Colors.red,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                tabs: tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(childCount: 10, (
                context,
                index,
              ) {
                return Card(
                  color: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text("Drink $index"),
                    ],
                  ),
                );
              }),

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
            ),
          ),
        ],
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
    return Container(child: tabBar);
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
