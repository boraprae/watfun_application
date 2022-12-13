import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:quickalert/quickalert.dart';
// import 'package:paletteartz/artworksetting/setting.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController paymentController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  String _token = '';

  //Image
  late BuildContext _context;
  late Map<dynamic, dynamic> imgData;

  //Get data from JSON server
  final String _userURL = "http://10.0.2.2:9000/user";
  late Future<List> _userInfo;
  bool _waitingUserInfo = true;

  //! Pick image function
  var _base64String;
  File? _image;
  File? _coverImage;
  String currentProfileImage = "";
  String currentCoverImage = "";

  @override
  void initState() {
    super.initState();
    _userInfo = getUserInformation();
  }

  Future updateDataToServer(context, userID, profileImage, coverImage) async {
    //TODO: Check if no have new image
    //TODO: If change the email
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    Response response = await GetConnect().patch(
        _userURL + "/" + userID.toString(),
        jsonEncode(<String, dynamic>{
          "username": usernameController.text,
          "payment_info": paymentController.text,
          "bio_text": bioController.text,
          "profile_image_path":
              currentProfileImage == "" ? profileImage : currentProfileImage,
          "cover_profile_image_path":
              currentCoverImage == "" ? coverImage : currentCoverImage,
        }));

    setState(() {
      // usernameController.clear();
      // emailController.clear();
      // paymentController.clear();
    });

    if (emailController.text != token) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Sorry",
        text: "You can't change the email for now.",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Success",
        text: "Your artwork already upload!",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
        onConfirmBtnTap: () {
          Navigator.pushNamed(context, "/mainMenu");
        },
      );
    }
  }

  Future pickProfileImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // read picked image byte data.
      Uint8List imagebytes = await image.readAsBytes();
      // using base64 encoder convert image into base64 string.
      _base64String = base64Encode(imagebytes);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        this._image = imagePermanent;
        currentProfileImage = _base64String;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickCoverProfileImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // read picked image byte data.
      Uint8List imagebytes = await image.readAsBytes();
      // using base64 encoder convert image into base64 string.
      _base64String = base64Encode(imagebytes);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        this._image = imagePermanent;
        currentCoverImage = _base64String;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //!Save to local storage
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
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

  Widget buildTextField(
      String labelText, String placeholder, TextEditingController controller) {
    controller.text = placeholder;
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
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //**------ profile cover image ---**
                            data[0]["cover_profile_image_path"] == "" &&
                                    currentCoverImage == ""
                                ? Container(
                                    height: 0.2 * size.height,
                                    width: size.width,
                                    child: Image.asset(
                                      'assets/img/neonBG.jpg',
                                      fit: BoxFit.fitWidth,
                                    ),
                                  )
                                : Container(
                                    height: 0.2 * size.height,
                                    width: size.width,
                                    child: Image.memory(
                                      currentCoverImage == null ||
                                              currentCoverImage == ""
                                          ? base64Decode(data[0]
                                              ["cover_profile_image_path"])
                                          : base64Decode(currentCoverImage),
                                      fit: BoxFit.fitWidth,
                                    ),
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
                                      paymentController),
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
                                        updateDataToServer(
                                            context,
                                            data[0]["id"],
                                            data[0]['profile_image_path'],
                                            data[0]
                                                ['cover_profile_image_path']);
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
                              //!Current Profile Image
                              data[0]["profile_image_path"] == "" &&
                                      currentProfileImage == ""
                                  ? CircleAvatar(
                                      backgroundColor: btnDark,
                                      //ToDo: Convert to base64
                                      radius: 0.12 * size.width,
                                      child: Text(
                                        data[0]["username"][0]
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))
                                  : CircleAvatar(
                                      radius: 0.12 * size.width,
                                      backgroundImage: MemoryImage(
                                        currentProfileImage == null ||
                                                currentProfileImage == ""
                                            ? base64Decode(
                                                data[0]["profile_image_path"])
                                            : base64Decode(currentProfileImage),
                                      ),
                                      // backgroundImage: NetworkImage('http://10.0.2.2:3000' +
                                      //     userInfoList['profile_image']),
                                    ),
                              Positioned(
                                bottom: 0.01 * size.width,
                                right: 0.01 * size.width,
                                child: InkWell(
                                  onTap: () {
                                    //!------ Function for uploade profile image paste here -----!
                                    pickProfileImage();
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
                                pickCoverProfileImage();
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
