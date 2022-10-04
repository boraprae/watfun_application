import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watfun_application/constantColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSetting extends StatefulWidget {
  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  String _token = '';
  var userInfoList;
  bool _waitingUserData = true;

  @override
  void initState() {
    super.initState();
    getToken();
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
      body:  _waitingUserData
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
                Navigator.pushNamed(context, '/editProfile');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage('http://10.0.2.2:3000' + userInfoList['profile_image']),
                    radius: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Plaette Artz name",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          userInfoList['username'],
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
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
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
                Navigator.pushNamed(context, '/changePassword');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
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
            ),
            Text(
              'Others',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/transaction');
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_clock_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Transactions history',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
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
