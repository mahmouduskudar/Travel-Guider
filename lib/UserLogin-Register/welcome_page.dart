import 'package:bitirmes/CustomClass/ImageWidget.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 193, 193, 2),
      body: Center(
        child: GestureDetector(
          child: IconWidget(
              isSignPage: false,
              imagePath: 'images/logo.png',
              widthSize: width / 3,
              HeightSize: height / 4),
          onTap: () {
            // removes the current page entirely
            // and deletes the back button from
            // the pushed screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginFormPage()),
            );
          },
        ),
      ),
    );
  }
}
