import 'package:bitirmes/CustomClass/ListTileWidget.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/GuiderPanel/GuiderinfoForm.dart';
import 'package:bitirmes/UserLogin-Register/welcome_page.dart';
import 'package:bitirmes/UserProfileClasses/booked_page.dart';
import 'package:bitirmes/UserProfileClasses/edit_profile_page.dart';
import 'package:bitirmes/UserProfileClasses/favorite_page.dart';
import 'package:bitirmes/UserProfileClasses/help_center_page.dart';
import 'package:flutter/material.dart';

import '../GuiderPanel/bookings_list.dart';
import '../UserLogin-Register/sign_in_page.dart';
import 'chat_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorItems.projectBackground,
      appBar: AppBar(
        title: Text(
          'Hello ${LoginFormPage.currentCustomer.fullName}',
        ),
      ),
      body: Padding(
        padding: ProjectPadding.pagePadding,
        child: ListView(children: <Widget>[
          if (LoginFormPage.currentCustomer.isCustomer)
            ListTileWidget(
              text: "Favorite",
              icon: Icon(
                Icons.favorite,
                size: 50,
              ),
              goToPage: favoritePage(),
            ),
          ListTileWidget(
            text: "Chats",
            icon: Icon(
              Icons.message_outlined,
              size: 50,
            ),
            goToPage: ChatPage(),
          ),
          if (LoginFormPage.currentCustomer.isCustomer)
            ListTileWidget(
              text: "Booked",
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 50,
              ),
              goToPage: BookedPage(),
            ),
          if (LoginFormPage.currentCustomer.isCustomer)
            ListTileWidget(
              text: "Change İnformation",
              icon: Icon(
                Icons.settings,
                size: 50,
              ),
              goToPage: EditProfilePage(),
            ),
          if (LoginFormPage.currentCustomer.isGuider)
            ListTileWidget(
              text: "Update Guider İnformation",
              icon: Icon(
                Icons.settings,
                size: 50,
              ),
              goToPage: GuiderInfoForm(),
            ),
          if (LoginFormPage.currentCustomer.isGuider)
            ListTileWidget(
              text: "Booked",
              icon: Icon(
                Icons.calendar_today_rounded,
                size: 50,
              ),
              goToPage: BookingsList(),
            ),
          ListTileWidget(
            text: "Help Center",
            icon: Icon(
              Icons.help_center,
              size: 50,
            ),
            goToPage: HelpCenter(),
          ),
          ListTileWidget(
            text: "Log Out",
            icon: Icon(
              Icons.logout,
              size: 50,
            ),
            onPressedAction: () async {
              await LoginFormPage.currentCustomer.logOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ]),
      ),
    );
  }
}
/*
*var bodyStr = await c.logOut();
* */
