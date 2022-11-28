import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_connect/http/src/response/response.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextField = TextEditingController();
  final passwordTextField = TextEditingController();
  bool showPassword = true;

  //Get User Data
  final String _url = "http://10.0.2.2:9000/user";
  late Future<List> _data;

  // @override
  // void initState() {
  //   super.initState();
  //   _data = getData();
  // }

  //Get Commission Offer
  Future<bool> userVerify(email, password) async {
    var response = await GetConnect().get(_url);
    if (response.status.isOk) {
      //check user in json-server
      var verifyStatus = false;
      List userInfo = await response.body;
      for (int i = 0; i < userInfo.length; i++) {
        if (email == userInfo[i]["email"] &&
            password == userInfo[i]["password"]) {
          verifyStatus = true;
        }
      }
      return verifyStatus;
    } else {
      throw Exception('Error');
    }
  }

  Future signIn() async {
    if (emailTextField.text == '' || passwordTextField.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Warning!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Please type your email and password first.'),
              ],
            ),
          );
        },
      );
    } else {
      // var Loging = await login();
      // saveToken(Loging.body);
      //!Change condition to Comparing Data from json-server
      var loginTicket =
          await userVerify(emailTextField.text, passwordTextField.text);
      if (loginTicket == true) {
        //Todo: use shared_preferences to keep the user email as a token
        // Obtain shared preferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', emailTextField.text);
        Navigator.pushNamed(context, '/mainMenu');
        emailTextField.clear();
        passwordTextField.clear();
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Error",
          text: "Your input incorrect!",
          confirmBtnText: "OK",
          confirmBtnColor: lightGray,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgBlack,
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage('assets/img/neonBG.jpg'),
              ),
            ),
          ),
          Container(
            height: size.height,
            width: size.width,
            color: Colors.black.withOpacity(0.5),
          ),
          BlurryContainer(
            blur: 35,
            width: size.width,
            height: size.height,
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(64.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF404040),
                      border: Border.all(color: Color(0xFF4E4E4E)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, '/welcome');
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Image.asset(
                          'assets/img/appLogo.png',
                          width: 30.0,
                          height: 30.0,
                        ),
                      ],
                    ),
                  ),

                  //username
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        controller: emailTextField,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      //password
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextFormField(
                        controller: passwordTextField,
                        style: TextStyle(color: Colors.white),
                        obscureText: showPassword,
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),

                  //forget password?
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        child: Text("Forget Password?"),
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 10),
                          primary: Colors.white,
                        ),
                        onPressed: () {}),
                  ),
                  //button sign in
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: SizedBox(
                      width: size.width,
                      height: 0.05 * size.height,
                      child: ElevatedButton(
                        onPressed: () async {
                          await signIn();
                          // Navigator.pushNamed(context, '/mainMenu');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          child: Text("Don't have account? Sign Up"),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signUp');
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

mixin Response {}
