import 'dart:io';

import 'package:bitirmes/CustomClass/ButtonWidget.dart';
import 'package:bitirmes/CustomClass/ImageWidget.dart';
import 'package:bitirmes/CustomClass/TextFieldWidget.dart';
import 'package:bitirmes/CustomClass/TextWidget.dart';
import 'package:bitirmes/Features/FeatureSelection.dart';
import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:bitirmes/services/cloud_storage.dart';
import 'package:bitirmes/tabbarClasses/customer_panel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../UserProfileClasses/user_profile.dart';

class FormPage extends StatefulWidget {
  @override
  State<FormPage> createState() => _FormPageState();

  static void clicked(BuildContext context, Widget className) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => className),
    );
  }
}

class _FormPageState extends State<FormPage> {
  // for terms and conditions
  bool isChecked = false;

  void setChecked(bool? value) {
    isChecked = value == true;

    setState(() {});
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  final TextEditingController dailyPriceController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  bool isCustomer = true;

  List<int> availableDays = [];
  File? guiderImage;
  List<File>? images;

  Future<void> Register() async {
    List<String> userNameSurname = usernameController.text.split(" ");

    Map<String, dynamic> bodyStr;

    String? guiderImgLink;
    List<String> imagesLinks = [];

    try {
      await EasyLoading.show(status: 'Loading...');

      if (guiderImage != null) {
        guiderImgLink = await CloudStorage.instance.uploadFile(guiderImage!);
      }

      if (images != null) {
        for (var e in images!) {
          try {
            final upld = await CloudStorage.instance.uploadFile(e);
            if (upld != null) {
              imagesLinks.add(upld);
            }
          } catch (e) {
            print(e);
          }
        }
      }

      if (isCustomer) {
        bodyStr = await LoginFormPage.currentCustomer.register(
          userNameSurname.first,
          userNameSurname.last,
          "0000000000",
          emailController.text,
          passwordController.text,
          repasswordController.text,
        );
      } else {
        bodyStr = await LoginFormPage.currentCustomer.registerGuider(
          userNameSurname.first,
          userNameSurname.last,
          "0000000000",
          emailController.text,
          passwordController.text,
          repasswordController.text,
          availableDays,
          guiderImgLink!,
          int.parse(dailyPriceController.text),
          bioController.text,
          imagesLinks,
        );
      }

      if (bodyStr["status"] == 1) {
        EasyLoading.showSuccess('Registered successfully');
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginFormPage()),
      );
    } catch (e) {
      EasyLoading.showError('Error occured');
    }
  }

  void goToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginFormPage()),
    );
  }

  void setAvailableDays(List<int> value) {
    availableDays = value;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 193, 193, 2),
      body: SafeArea(
        child: ListView(
          children: [
            IconWidget(
              isSignPage: true,
              imagePath: 'images/logo.png',
              widthSize: width / 15,
              HeightSize: height / 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Guider'),
                Switch.adaptive(
                  value: isCustomer,
                  onChanged: (value) {
                    isCustomer = value;

                    setState(() {});
                  },
                ),
                Text('Customer'),
              ],
            ),
            ...[
              TextWidget(text: "User Name", styleParam: ThemeClass.headline4),
              TextFieldWidget(
                  sizeHeight: height, controllerParam: usernameController),
            ],
            ...[
              TextWidget(text: "Email", styleParam: ThemeClass.headline4),
              TextFieldWidget(
                  sizeHeight: height, controllerParam: emailController),
            ],
            ...[
              TextWidget(text: "Password", styleParam: ThemeClass.headline4),
              TextFieldWidget(
                sizeHeight: height,
                controllerParam: passwordController,
                hideInput: true,
              ),
            ],
            ...[
              TextWidget(text: "Re-Password", styleParam: ThemeClass.headline4),
              TextFieldWidget(
                sizeHeight: height,
                controllerParam: repasswordController,
                hideInput: true,
              ),
            ],
            if (!isCustomer) ...[
              ...[
                TextWidget(
                    text: "Daily price", styleParam: ThemeClass.headline4),
                TextFieldWidget(
                  sizeHeight: height,
                  controllerParam: dailyPriceController,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                ),
              ],
              ...[
                TextWidget(text: "Bio", styleParam: ThemeClass.headline4),
                TextFieldWidget(
                  sizeHeight: height,
                  controllerParam: bioController,
                  maxLines: 5,
                ),
              ],
              Builder(
                builder: (context) {
                  final isPicked = guiderImage != null;

                  return InkWell(
                    onTap: () async {
                      final img = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );

                      if (img != null) {
                        guiderImage = File(img.path);
                      }

                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      decoration: BoxDecoration(
                        color: isPicked ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          isPicked
                              ? '(Image picked) Update your profile image'
                              : 'Pick your profile image',
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Builder(
                builder: (context) {
                  final isPicked = images != null;

                  return InkWell(
                    onTap: () async {
                      final imgs = await ImagePicker().pickMultiImage();

                      if (imgs.isNotEmpty) {
                        images = imgs.map(
                          (e) {
                            return File(e.path);
                          },
                        ).toList();
                      }

                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 100,
                      decoration: BoxDecoration(
                        color: isPicked ? Colors.green : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          isPicked
                              ? '(Image picked) Update your gallery images'
                              : 'Pick your places images',
                        ),
                      ),
                    ),
                  );
                },
              ),
              ...[
                TextWidget(
                    text: "Available Days", styleParam: ThemeClass.headline4),
                AvailableDaysPicker(
                  initialAvailableDays: availableDays,
                  setAvailableDays: setAvailableDays,
                ),
              ],
            ],
            CreateTermsConditionsWidget(
              isChecked: isChecked,
              setIsChecked: setChecked,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  child: ButtonWidget(
                    text: "Sign up",
                    pressedKey: isChecked ? Register : null,
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
                "Do you have an account",
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
                    text: "Sign in",
                    pressedKey: goToSignUp,
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

class CreateTermsConditionsWidget extends StatelessWidget {
  final bool isChecked;
  final void Function(bool? value) setIsChecked;

  CreateTermsConditionsWidget({
    required this.isChecked,
    required this.setIsChecked,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(var isChecked) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Terms and Conditions'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Terms of Service'),
                  Text('Terms of Service details'),
                  ElevatedButton(
                      onPressed: () {
                        print('burası calıstı');
                        Navigator.of(context, rootNavigator: true).pop();
                        isChecked = true;
                      },
                      child: Text("Accept")),
                ],
              ),
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 0.0, right: 0.0),
      child: Row(
        children: [
          Checkbox(
            activeColor: Colors.green,
            value: isChecked,
            onChanged: setIsChecked,
          ),
          RichText(
            maxLines: 3,
            text: TextSpan(
              style: TextStyle(color: Colors.white60),
              children: <TextSpan>[
                TextSpan(text: 'By creating account you are agree on our \n '),
                TextSpan(
                    text: 'terms conditions',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('Terms of Service');
                        _showMyDialog(isChecked);
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AvailableDaysPicker extends StatefulWidget {
  final void Function(List<int> availableDays) setAvailableDays;
  final List<int> initialAvailableDays;
  const AvailableDaysPicker({
    super.key,
    required this.setAvailableDays,
    required this.initialAvailableDays,
  });

  @override
  State<AvailableDaysPicker> createState() => _AvailableDaysPickerState();
}

class _AvailableDaysPickerState extends State<AvailableDaysPicker> {
  List<int> availableDays = [];

  void setAvailableDays(List<int> availableDays) {
    setState(() {
      this.availableDays = availableDays;
    });
    widget.setAvailableDays(availableDays);
  }

  @override
  void initState() {
    availableDays = widget.initialAvailableDays;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ].asMap();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      child: Wrap(
        children: days.entries.map(
          (e) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ChoiceChip(
                label: Text(e.value),
                selected: availableDays.contains(e.key),
                onSelected: (selected) {
                  if (selected) {
                    availableDays.add(e.key);
                  } else {
                    availableDays.remove(e.key);
                  }
                  setAvailableDays(availableDays);
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
