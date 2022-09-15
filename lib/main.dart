import 'package:flutter/material.dart';
import 'package:watfun_application/login/signUp.dart';
import 'package:watfun_application/mainMenu.dart';
import 'package:watfun_application/welcomePage.dart';

import 'login/signIn.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomePage(),
        '/signIn': (context) => LoginPage(),
        '/signUp': (context) => RegisterPage(),
        '/mainMenu': (context) => MainMenu(),
      },
    ),
  );
}
