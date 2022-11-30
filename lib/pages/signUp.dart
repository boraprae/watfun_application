import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/pages/shared/listUserData.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = true;
  //Get User Data
  final String _url = "http://10.0.2.2:9000/user";
  late Future<UserData> futureUserData;
  late Future<List> _userData;

  @override
  void initState() {
    super.initState();
    _userData = getUserData();
  }

  //Get User Info
  Future<List> getUserData() async {
    Response response = await GetConnect().get(_url);
    if (response.status.isOk) {
      // setState(() {
      //   _waiting = false;
      // });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  Future signUp() async {
    if (usernameController.text == '' ||
        emailController.text == '' ||
        passwordController.text == '') {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: "Warning",
        text: "You have to complete all fields.",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
      );
    } else {
      // send data to json server
      print(emailController.text);
      print(usernameController.text);
      print(passwordController.text);
      Response response = await GetConnect().post(
        _url,
        jsonEncode(
          <String, dynamic>{
            "username": usernameController.text,
            "email": emailController.text,
            "password": passwordController.text,
            "payment_info": "",
            "bio_text": "",
            "profile_image_path": "assets/artworksUploads/05.jpg",
            "cover_profile_image_path": "",
          },
        ),
      );
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Success",
        text: "You are our member now!",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
        onConfirmBtnTap: () {
          Navigator.pushNamed(context, '/welcome');
        },
      );
      emailController.clear();
      usernameController.clear();
      passwordController.clear();
    }
  }

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
                          controller: usernameController,
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
                          controller: emailController,
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
                          controller: passwordController,
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
                            await signUp();
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
