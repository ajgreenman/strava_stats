import 'package:flutter/material.dart';
import 'package:strava_stats/pages/widgets/grouped_totals.dart';
import 'package:strava_stats/pages/widgets/ranged_totals.dart';

class TotalsScreen extends StatefulWidget {
  @override
  _TotalsScreenState createState() => _TotalsScreenState();
}

class _TotalsScreenState extends State<TotalsScreen> with SingleTickerProviderStateMixin {
  final _tabs = [
    Tab(child: Text('Ranged Totals')),
    Tab(child: Text('Grouped Totals')),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: _tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            child: DefaultTabController(
              length: _tabs.length,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    _buildAppBar(innerBoxIsScrolled),
                    _buildTabBarHeader(),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    RangedTotals(),
                    GroupedTotals(),
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool innerBoxIsScrolled) {
    const expandedHeight = 150.0;

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        return SliverAppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.grey[300],
          iconTheme: IconThemeData(color: Colors.white),
          expandedHeight: expandedHeight,
          pinned: true,
          floating: true,
          title: AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            child: Text('Activity Totals',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            opacity: constraints.scrollOffset != 0 ? 1 : 0,
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
            title: AnimatedOpacity(
              duration: Duration(milliseconds: 50),
              child: Text('Activity Totals',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              opacity: constraints.scrollOffset == 0 ? 1 : 0,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBarHeader() => SliverPersistentHeader(
    delegate: _SliverTabBarDelegate(
      TabBar(
        controller: _tabController,
        labelColor: Colors.deepOrange,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 5,
        labelPadding: EdgeInsets.all(5),
        indicatorColor: Colors.deepOrange,
        tabs: _tabs,
      ),
    ),
    pinned: true,
  );
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}