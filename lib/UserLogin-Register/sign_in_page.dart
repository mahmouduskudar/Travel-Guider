import 'package:bitirmes/CustomClass/ButtonWidget.dart';
import 'package:bitirmes/CustomClass/ImageWidget.dart';
import 'package:bitirmes/CustomClass/TextFieldWidget.dart';
import 'package:bitirmes/CustomClass/TextWidget.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/ObjectClasses/customer.dart';
import 'package:bitirmes/UserLogin-Register/sign_up_page.dart';
import 'package:bitirmes/chat/managers/client_manager.dart';
import 'package:bitirmes/tabbarClasses/customer_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../UserProfileClasses/user_profile.dart';

class LoginFormPage extends ConsumerWidget {
  static User currentCustomer = User();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void goToSignIn() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FormPage()),
      );
    }

    Future<void> Login() async {
      await EasyLoading.show(status: 'Loading...');

      // ahmet.ak@gmail.com  1234
      var bodyStr = await currentCustomer.login(
          emailController.text, passwordController.text);
      if (bodyStr["status"] == 1) {
        await currentCustomer.profile();
        await ClientManager.auth(ref);

        EasyLoading.dismiss();

        if (LoginFormPage.currentCustomer.isCustomer) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerPanel(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          );
        }
      } else {
        EasyLoading.showError(bodyStr["message"]);
      }

      print(currentCustomer.token);
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 193, 193, 2),
      body: SafeArea(
        child: ListView(
          children: [
            IconWidget(
                isSignPage: true,
                imagePath: 'images/logo.png',
                widthSize: width / 5,
                HeightSize: height / 6),
            TextWidget(
              text: "Email",
              styleParam: ThemeClass.headline4,
            ),
            TextFieldWidget(
              sizeHeight: height,
              controllerParam: emailController,
            ),
            TextWidget(
              text: "Password",
              styleParam: ThemeClass.headline4,
            ),
            TextFieldWidget(
              sizeHeight: height,
              controllerParam: passwordController,
              hideInput: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: ButtonWidget(
                    text: "Sign in",
                    pressedKey: Login,
                    styleParam: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Text(
                "Do not have an account",
                style: ThemeClass.headline4,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: ButtonWidget(
                    text: "Sign up",
                    pressedKey: goToSignIn,
                    styleParam: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
