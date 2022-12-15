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
  bool disableBackBtn = false;

  @override
  void initState() {
    super.initState();
    //getToken();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(data['user_info']);
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
                        data['user_info']["profile_image_path"] == null ||
                                data['user_info']["profile_image_path"] == ""
                            ? CircleAvatar(
                                radius: 20,
                                backgroundColor: btnDark,
                                //ToDo: Convert to base64
                                child: Text(
                                  data['user_info']["username"][0]
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: btnDark,
                                //ToDo: Convert to base64
                                backgroundImage: MemoryImage(
                                  base64Decode(
                                      data['user_info']['profile_image_path']),
                                ),
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
                                data['user_info']['username'],
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
