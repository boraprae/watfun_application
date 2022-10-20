import 'package:flutter/material.dart';
import 'package:watfun_application/pages/artworkDeatil.dart';
import 'package:watfun_application/pages/orderCommission.dart';
import 'package:watfun_application/pages/searchingOffer.dart';
import 'package:watfun_application/pages/signUp.dart';
import 'package:watfun_application/mainMenu.dart';
import 'package:watfun_application/welcomePage.dart';

import 'pages/signIn.dart';

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
        '/searchOffer': (context) => SearchingOffer(),
        '/orderCommission': (context) => OrderCommission(),
        '/artworkDetail': (context) => ArtworkDetail()
      },
    ),
  );
}
