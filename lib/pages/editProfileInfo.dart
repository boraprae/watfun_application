import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  //Get data from JSON server
  final String _userURL = "http://10.0.2.2:9000/user";
  late Future<List> _userInfo;
  bool _waitingUserInfo = true;

  @override
  void initState() {
    super.initState();
    _userInfo = getUserInformation();
  }

  //Get User Data
  Future<List> getUserInformation() async {
    //get email as a token for identify who is current user
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    Response response = await GetConnect().get(_userURL + "?email=" + token!);
    if (response.status.isOk) {
      setState(() {
        _waitingUserInfo = false;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
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
          enabledBorder: const UnderlineInputBorder(
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
          hintStyle: const TextStyle(
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: bgBlack,
      body: SingleChildScrollView(
        child: _waitingUserData
            ? const Center(
                child: CircularProgressIndicator(
                backgroundColor: bgBlack,
                color: purpleG,
              ))
            : FutureBuilder(
                future: _userInfo,
                builder: (context, snapshot) {
                  late List data = snapshot.data as List;
                  if (snapshot.hasData) {
                    Stack(
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
                                  buildTextField('Name', data[0]['username'],
                                      usernameController),
                                  buildTextField('Email', data[0]['email'],
                                      emailController),
                                  buildTextField(
                                      "Payment Information",
                                      data[0]['payment_info'],
                                      phoneNumberController),
                                  buildTextField("Bio", data[0]['bio_text'],
                                      bioController),
                                  // buildTextField("Art Style", userInfoList['tags'],
                                  //     tagController),
                                  SizedBox(
                                    height: 0.05 * size.height,
                                    width: size.width,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: purpleG,
                                          width: 1,
                                        ),
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
                                backgroundImage:
                                    AssetImage('assets/artworksUploads/05.jpg'),
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
                            child: OutlinedButton(
                              onPressed: () {
                                //!----- Function for change profile cover paste here------
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 0.5,
                                ),
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
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  return const Center(
                      child: const CircularProgressIndicator(
                    backgroundColor: bgBlack,
                    color: purpleG,
                  ));
                }),
      ),
    );
  }
}
