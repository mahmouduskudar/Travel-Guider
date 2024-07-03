import 'package:bitirmes/CustomClass/ButtonWidget.dart';
import 'package:bitirmes/CustomClass/TextFieldWidget.dart';
import 'package:bitirmes/CustomClass/TextWidget.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:bitirmes/UserProfileClasses/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final TextEditingController emailController = TextEditingController();
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController renewPasswordController =
        TextEditingController();
    final TextEditingController editController = TextEditingController();
    return Scaffold(
      backgroundColor: ColorItems.projectBackground,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            UnderlinedTextFieldWidget(
              message: 'Edit Username',
              controllerParam: editController,
            ),
            SizedBox(height: height / 20),
            TextWidget(
              text: "Edit Password :",
              styleParam: ThemeClass.headline5,
            ),
            UnderlinedTextFieldWidget(
              controllerParam: oldPasswordController,
              message: "Type Old Password",
              hideInput: true,
            ),
            UnderlinedTextFieldWidget(
              controllerParam: newPasswordController,
              message: "Type New Password",
              hideInput: true,
            ),
            UnderlinedTextFieldWidget(
              controllerParam: renewPasswordController,
              message: "Re-Type New Password",
              hideInput: true,
            ),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: ButtonWidget(
                    text: "Save Change",
                    pressedKey: () async {
                      var bodyStr = await LoginFormPage.currentCustomer
                          .changePassword(
                              oldPasswordController.text,
                              newPasswordController.text,
                              renewPasswordController.text);

                      if (bodyStr["status"] == 1) {
                        EasyLoading.showSuccess(bodyStr["message"]);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      } else {
                        EasyLoading.showError(bodyStr["message"]);
                      }
                    },
                    styleParam: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueAccent),
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
            //LoginButtonWidget(text: "Save Change"),
          ],
        ),
      ),
    );
  }
}

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      //  padding: const EdgeInsets.only(left: 120.0, right: 120),
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 40,
        //height: MediaQuery.of(context).size.height / 14,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 50),
            ),
            backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(0, 175, 175, 75)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
