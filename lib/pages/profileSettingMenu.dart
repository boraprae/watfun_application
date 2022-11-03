import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:watfun_application/appBar.dart';
import 'package:get/get.dart';

class ProfileSettingMenu extends StatefulWidget {
  @override
  State<ProfileSettingMenu> createState() => _ProfileSettingMenuState();
}

class _ProfileSettingMenuState extends State<ProfileSettingMenu> {
  String _token = '';
  var userInfoList;
  //Todo: the bool default value is true
  bool _waitingUserData = false;

  @override
  void initState() {
    super.initState();
    //getToken();
  }

  // void getToken() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? userString = await pref.getString('user');

  //   var userObject = jsonDecode(userString!) as Map<String, dynamic>;
  //   _token = userObject['token'];
  //   getUserDataAPI(_token);
  // }

  // void getUserDataAPI(String token) async {
  //   http.Response userInfoResponse = await getUserInfo(token);
  //   setState(() {
  //     userInfoList = jsonDecode(userInfoResponse.body);
  //     _waitingUserData = false;
  //   });
  // }

  // Future<http.Response> getUserInfo(String token) {
  //   return http.get(
  //     Uri.parse('http://10.0.2.2:3000/api/profile'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': token,
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        title: Text(
          'Settings',
        ),
        backgroundColor: bgBlack,
      ),
      body: _waitingUserData
          ? Center(
              child: const CircularProgressIndicator(
              backgroundColor: bgBlack,
              color: purpleG,
            ))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/editProfileInfo',
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/artworksUploads/05.jpg'),
                          // backgroundImage:
                          //     NetworkImage('http://10.0.2.2:3000' + userInfoList['profile_image']),
                          radius: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Username",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              //TODO: connect to API
                              Text(
                                'userInfoList',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.create,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: const Text(
                      'Application Settings',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("object");
                      Navigator.pushNamed(context, '/changePassword');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.vpn_key_sharp,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Change Password',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    child: Text(
                      'Others',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  //!---- Log out tap need to connect with logout function -----!
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/welcome');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Log out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
