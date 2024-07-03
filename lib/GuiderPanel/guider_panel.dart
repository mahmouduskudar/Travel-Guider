import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/GuiderPanel/GuiderinfoForm.dart';
import 'package:bitirmes/GuiderPanel/bookings_list.dart';
import 'package:flutter/material.dart';

class GuiderPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: menu(),
        body: TabBarView(
          children: [
            GuiderInfoForm(),
            BookingsList(),
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
            icon: Icon(Icons.person),
          ),
          Tab(
            icon: Icon(Icons.book_online),
          ),
        ],
      ),
    );
  }
}
