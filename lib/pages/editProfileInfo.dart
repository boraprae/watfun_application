import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:paletteartz/artworksetting/setting.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //TODO: The default bool is true
  bool _waitingUserData = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController tagController = TextEditingController();

  String _token = '';
  var userInfoList;

  @override
  void initState() {
    super.initState();
    // getToken();
  }

  void getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userString = await pref.getString('user');

    var userObject = jsonDecode(userString!) as Map<String, dynamic>;
    _token = userObject['token'];
    getUserDataAPI(_token);
  }

  void getUserDataAPI(String token) async {
    http.Response userInfoResponse = await getUserInfo(token);
    setState(() {
      userInfoList = jsonDecode(userInfoResponse.body);
      _waitingUserData = false;
    });
  }

  Future<http.Response> getUserInfo(String token) {
    return http.get(
      Uri.parse('http://10.0.2.2:3000/api/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );
  }

  Widget buildTextField(String labelText, String placeholder, var controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _waitingUserData
        ? Center(
            child: const CircularProgressIndicator(
            backgroundColor: bgBlack,
            color: purpleG,
          ))
        : Scaffold(
            appBar: AppBar(
              title: Text("Edit Profile"),
              backgroundColor: Colors.black,
            ),
            backgroundColor: bgBlack,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //**------ profile cover image ---**
                      Container(
                        height: 0.2 * size.height,
                        width: size.width,
                        child: Image.asset(
                          'assets/artworksUploads/02.jpg',
                          fit: BoxFit.fitWidth,
                        ),
                        // child: Image.network(
                        //   'http://10.0.2.2:3000' + userInfoList['cover_image'],
                        //   fit: BoxFit.fitWidth,
                        // ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 60, 32, 8),
                        child: Column(
                          children: [
                            buildTextField('Name', "userInfoList['username']",
                                usernameController),
                            buildTextField('Email', "userInfoList['email']",
                                emailController),
                            buildTextField(
                                "Phone Number",
                               " userInfoList['phone_number']",
                                phoneNumberController),
                            buildTextField("Gender", "userInfoList['gender']",
                                genderController),
                            buildTextField(
                                "Bio", "userInfoList['bio']", bioController),
                            // buildTextField("Art Style", userInfoList['tags'],
                            //     tagController),
                            SizedBox(
                              height: 0.05 * size.height,
                              width: size.width,
                              child: OutlineButton(
                                borderSide: BorderSide(
                                  color: purpleG,
                                  width: 1,
                                ),
                                onPressed: () {
                                  //!------ Function for save button here -------!
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => Profile()),
                                  // );
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: purpleG,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0.1 * size.height,
                    left: 0.05 * size.width,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 0.12 * size.width,
                          backgroundImage: AssetImage('assets/artworksUploads/05.jpg'),
                          // backgroundImage: NetworkImage('http://10.0.2.2:3000' +
                          //     userInfoList['profile_image']),
                        ),
                        Positioned(
                          bottom: 0.01 * size.width,
                          right: 0.01 * size.width,
                          child: InkWell(
                            onTap: () {
                              //!------ Function for uploade profile image paste here -----!
                            },
                            child: CircleAvatar(
                              radius: 0.03 * size.width,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.edit,
                                size: 0.025 * size.width,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0.16 * size.height,
                    right: 0.03 * size.width,
                    child: SizedBox(
                      height: 0.03 * size.height,
                      child: OutlineButton(
                        onPressed: () {
                          //!----- Function for change profile cover paste here------
                        },
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.5,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 0.025 * size.width,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              'Upload Cover Photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
