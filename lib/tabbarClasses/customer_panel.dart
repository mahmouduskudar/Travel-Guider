import 'package:bitirmes/BlogClasses/blog_page.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/UserProfileClasses/user_profile.dart';
import 'package:flutter/material.dart';

import '../MainScreen/map_screen.dart';

class CustomerPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        bottomNavigationBar: menu(),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            NewsScreen(),
            MapScreen(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: ColorItems.newsWidgetBackGroundColor,
      child: TabBar(
        padding: EdgeInsets.symmetric(vertical: 12),
        labelColor: Color.fromARGB(255, 0, 0, 0),
        unselectedLabelColor: Colors.grey[400],
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.transparent,
        tabs: [
          Tab(
            icon: Icon(Icons.group_work_outlined),
          ),
          Tab(
            icon: Icon(Icons.location_on_outlined),
          ),
          Tab(
            icon: Icon(Icons.people_alt_rounded),
          ),
        ],
      ),
    );
  }
}
