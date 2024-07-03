import 'package:bitirmes/UserLogin-Register/sign_in_page.dart';
import 'package:bitirmes/UserLogin-Register/welcome_page.dart';
import 'package:bitirmes/chat/managers/client_manager.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> initLocalData() async {
  final prefs = await SharedPreferences.getInstance();

  final fullName = prefs.getString('fullname');
  final token = prefs.getString('token');

  if (fullName != null) {
    LoginFormPage.currentCustomer.fullName = fullName;
  }
  if (token != null) {
    LoginFormPage.currentCustomer.token = token;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initLocalData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(builder: (context, ref, _) {
        ClientManager.setListener(ref);

        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color.fromRGBO(11, 193, 193, 2),
            textTheme: const TextTheme(
              headline1: TextStyle(
                // headline 1 is used in Titles
                fontSize: 24,
                fontWeight: FontWeight.bold,
                wordSpacing: 2,
                letterSpacing: 2,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
              headline2: TextStyle(
                //headline 2 is used in Descraption
                wordSpacing: 2,
                letterSpacing: 2,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          // home: MapScreen(),
          home: WelcomeScreen(),
          // home: LoginFormPage.currentCustomer.token != ''
          //     ? CustomerPanel()
          //     : WelcomeScreen(),
          builder: EasyLoading.init(),
        );
      }),
    );
  }
}
