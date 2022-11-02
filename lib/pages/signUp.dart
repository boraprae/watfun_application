import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/pages/shared/listUserData.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameTextField = TextEditingController();
  final emailTextField = TextEditingController();
  final passwordTextField = TextEditingController();
  bool showPassword = true;
  //Get User Data
  final String _url = "http://localhost:9000/user";
  late Future<UserData> futureUserData;

  @override
  void initState() {
    super.initState();
    futureUserData = fetchData();
    // print(futureUserData);
  }

  // Future<http.Response> fetchUserData() async {
  //   return http.get(Uri.parse(_url));
  // }

  Future<UserData> fetchData() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
  // Future<http.Response> signUp() {
  //   return http.post(
  //     Uri.parse('http://localhost:9000/user'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'username': usernameTextField.text,
  //       'email': emailTextField.text,
  //       'password': passwordTextField.text,
  //     }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgBlack,
      body: SafeArea(
        child: Stack(
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
                            'Sign up',
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
                          'Username',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextFormField(
                          controller: usernameTextField,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        //Email
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
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        //Password
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
                    ), //button sign in
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: SizedBox(
                        width: size.width,
                        height: 0.05 * size.height,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (usernameTextField.text == '' ||
                                emailTextField.text == '' ||
                                passwordTextField.text == '') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Warning!'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            'You have to complete all fields.'),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              // await signUp();
                              emailTextField.clear();
                              usernameTextField.clear();
                              passwordTextField.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    //if not have acc

                    Center(
                      child: TextButton(
                          child: Text("Already have account? Sign In"),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signIn');
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
