import 'package:flutter/material.dart';

class ProjectPadding {
  static const pagePadding = EdgeInsets.all(16);
  static const LoginPadding = EdgeInsets.only(top: 15);
  static const ProfileDividerPadding =
      EdgeInsets.only(bottom: 10, right: 10, left: 10, top: 10);
  static const newsWisgetPadding =
      EdgeInsets.all(14); // the padding between image and text
  static const FavoritePadding = EdgeInsets.only(top: 8, left: 10, right: 10);
  static const EditPadding = EdgeInsets.only(top: 30, left: 30, right: 10);
  static const CardsPadding = EdgeInsets.only(top: 5, left: 2);
}

class ColorItems {
  static const Color newsWidgetBackGroundColor =
      Color.fromRGBO(243, 243, 243, 15);
  static const Color newsCardShadowColor = Colors.grey;
  static const Color projectBackground = Colors.white;
  static const Color projectBlue = Colors.blue;
  static const Color projectGreen = Colors.green;
}

class ThemeClass {
  static const TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    wordSpacing: 2,
    letterSpacing: 2,
    color: Colors.black,
    overflow: TextOverflow.ellipsis,
  );
  static const TextStyle headline2 = TextStyle(
    wordSpacing: 2,
    letterSpacing: 2,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
  static const TextStyle headline3 = TextStyle(
    wordSpacing: 1.6,
    letterSpacing: 2,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  static const TextStyle headline4 = TextStyle(
    wordSpacing: 1.0,
    letterSpacing: 2,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  //for edit profile
  static const TextStyle headline5 = TextStyle(
    letterSpacing: 2,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}
