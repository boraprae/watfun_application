import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextField = TextEditingController();
  final passwordTextField = TextEditingController();
  bool showPassword = true;

  void saveToken(var body) async {
    Map object = jsonDecode(body) as Map<String, dynamic>;
    print(object['token']);

    setState(() {});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String objectString = jsonEncode(object);

    prefs.setString('user', objectString);
  }

  Future<http.Response> login() {
    return http.post(
      Uri.parse('http://10.0.2.2:3000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailTextField.text,
        'password': passwordTextField.text
      }),
    );
  }

  Future loginFailed(String alertMessage) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(alertMessage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Wrong username or password'),
            ],
          ),
        );
      },
    );
    emailTextField.clear();
    passwordTextField.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgBlack,
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Container(
          width: 0.9 * size.width,
          height: 1.0 * size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Sign in',
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

              //username
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Column(
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
              SizedBox(
                width: size.width,
                height: 0.05 * size.height,
                child: ElevatedButton(
                  onPressed: () async {
                    // if (emailTextField.text == '' ||
                    //     passwordTextField.text == '') {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         title: Text('Warning!'),
                    //         content: Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Text(
                    //                 'Please type your email and password first.'),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   );
                    // } else {
                    //   var Loging = await login();
                    //   saveToken(Loging.body);
                    //   if (Loging.statusCode < 299) {
                    //     Navigator.pushNamed(context, '/mainMenu');
                    //     emailTextField.clear();
                    //     passwordTextField.clear();
                    //   } else {
                    //     loginFailed(Loging.body);
                    //   }
                    // }
                     Navigator.pushNamed(context, '/mainMenu');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                    child: Text("Don't have account? Sing Up"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signUp');
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin Response {}
