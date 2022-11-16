import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class CreateNewPost extends StatefulWidget {
  const CreateNewPost({Key? key}) : super(key: key);

  @override
  _CreateNewPostState createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  TextEditingController artTitleController = TextEditingController();
  TextEditingController artDescriptionController = TextEditingController();
  TextEditingController artTagController = TextEditingController();

  //Commission Controller
  TextEditingController offerTitleController = TextEditingController();
  TextEditingController offerDescriptionController = TextEditingController();
  TextEditingController offerPriceController = TextEditingController();
  TextEditingController offerResultController = TextEditingController();

  //Image
  late BuildContext _context;
  late Map<dynamic, dynamic> imgData;

  //! Pick image function
  File? _image;
  var artStyleValue = 'Select Style of Arts';
  var createTypeValue = 'Select Type of Creation';
  //Get category
  final String _categoryURL = "http://10.0.2.2:9000/artworkCategory";
  final String _artworkURL = "http://10.0.2.2:9000/artworks";
  final String _commissionOfferURL = "http://10.0.2.2:9000/commission_offer";
  late Future<List> _data;
  late Future<List> _artworkCategory;
  var _base64String;

  @override
  void initState() {
    super.initState();
    //Not check loading data yet
    getCategory();
  }

  //Get category List
  Future<List> getCategory() async {
    Response response = await GetConnect().get(_categoryURL);
    if (response.status.isOk) {
      setState(() {
        //Update dropdown list
        var _data = response.body;
        for (int i = 1; i < _data.length; i++) {
          //add art style to dropdown value
          styleItem.add(response.body[i]["name"]);
        }
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  Future pickImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // read picked image byte data.
      Uint8List imagebytes = await image.readAsBytes();

      // using base64 encoder convert image into base64 string.
      _base64String = base64Encode(imagebytes);
      print(_base64String);
      // final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        this._image = imagePermanent;
      });
      // print(_image!.path);
      // setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future addNewPostToServer() async {
    //TODO: 1. Check condition of createTypeValue 2.Null check operator
    if (createTypeValue == 'Create Artwork Post') {
      Response response = await GetConnect().post(
        _artworkURL,
        jsonEncode(<String, dynamic>{
          "art_title": artTitleController.text,
          "art_description": artDescriptionController.text,
          "art_type": artStyleValue,
          "art_image_base64": _base64String,
          "art_created_date": "Sep 4, 2021",
          "user_id_user": 1,
          "username": "Jenny Kim",
          "profile_image_path": "assets/artworksUploads/11.jpg"
        }),
      );
      print(response.statusCode);
    } else if (createTypeValue == 'Create Commission Offer') {
      Response response = await GetConnect().post(
        _commissionOfferURL,
        jsonEncode(<String, dynamic>{
          "offer_title": offerTitleController.text,
          "offer_description": offerDescriptionController.text,
          "offer_price": offerPriceController.text,
          "offer_art_type": artStyleValue,
          "offer_result": offerResultController.text,
          "offer_image_base64": _base64String,
          "offer_create_date": "Sep 4, 2021",
          "user_id_user": 1,
          "username": "Jenny Kim",
          "profile_image_path": "assets/artworksUploads/11.jpg"
        }),
      );
    }
  }

  //!Save to local storage
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future showAlert(String title, String alertMessage) async {
    await showDialog(
      context: _context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(alertMessage),
            ],
          ),
        );
      },
    );
  }

  //! dropdown static value
  var styleItem = [
    'Select Style of Arts',
  ];

  var uploadType = [
    'Select Type of Creation',
    'Create Commission Offer',
    'Create Artwork Post',
  ];

  @override
  Widget build(BuildContext context) {
    _context = context;
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //!Add images button area
            Container(
              height: 0.3 * size.height,
              width: size.width,
              decoration: BoxDecoration(color: darkLight),
              child: _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.fitWidth,
                    )
                  : TextButton(
                      onPressed: () => pickImage(),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 0.05 * size.height,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Tap to select your artworks',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            //!Add title image area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //!!Dropdown for select the upload type area not disable the first choice yet :(
                  //Todo: Find solution to fix error in framework
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: lightGray),
                    height: 50,
                    child: Row(
                      children: [
                        DropdownButton(
                          value: createTypeValue,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return uploadType.map((String uploadType) {
                              return Text(
                                uploadType,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              );
                            }).toList();
                          },
                          underline: SizedBox(),
                          items: uploadType.map((String uploadType) {
                            return DropdownMenuItem(
                              child: Text(uploadType),
                              value: uploadType,
                            );
                          }).toList(),
                          //createTypeValue here
                          onChanged: (String? updateValue) {
                            setState(() {
                              createTypeValue = updateValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  //**######## On change upload form ########**
                  createTypeValue == "Create Commission Offer"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: offerTitleController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: const TextStyle(
                                        fontSize: 12.0, color: grayText),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: pinkG, width: 0.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0.01 * size.height,
                            ),
                            //!Add description area
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: offerDescriptionController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Description',
                                    hintStyle: TextStyle(
                                        fontSize: 12.0, color: grayText),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: pinkG, width: 0.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: offerPriceController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Price',
                                    hintStyle: TextStyle(
                                        fontSize: 12.0, color: grayText),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: pinkG, width: 0.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //!!Dropdown area not disable the first choice yet :(
                            Container(
                              width: size.width,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: lightGray),
                              height: 50,
                              child: Row(
                                children: [
                                  DropdownButton(
                                    value: artStyleValue,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return styleItem.map((String styleItem) {
                                        return Text(
                                          styleItem,
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        );
                                      }).toList();
                                    },
                                    underline: SizedBox(),
                                    items: styleItem.map((String styleItem) {
                                      return DropdownMenuItem(
                                        child: Text(styleItem),
                                        value: styleItem,
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        artStyleValue = newValue!;
                                        print(artStyleValue);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            //! End of Dropdown
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: offerResultController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Add the result of artwork commission..',
                                    hintStyle: TextStyle(
                                        fontSize: 12.0, color: grayText),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: pinkG, width: 0.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                'Title',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: artTitleController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: TextStyle(
                                        fontSize: 12.0, color: grayText),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: pinkG, width: 0.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0.01 * size.height,
                            ),
                            //!Add description area
                            Text(
                              'Description',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                              child: SizedBox(
                                height: 50,
                                child: TextField(
                                  controller: artDescriptionController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'Description',
                                    hintStyle: TextStyle(
                                        fontSize: 12.0, color: grayText),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide:
                                          BorderSide(color: pinkG, width: 0.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //!!Dropdown area not disable the first choice yet :(
                            Container(
                              width: size.width,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: lightGray),
                              height: 50,
                              child: Row(
                                children: [
                                  DropdownButton(
                                    value: artStyleValue,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    selectedItemBuilder:
                                        (BuildContext context) {
                                      return styleItem.map((String styleItem) {
                                        return Text(
                                          styleItem,
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        );
                                      }).toList();
                                    },
                                    underline: SizedBox(),
                                    items: styleItem.map((String styleItem) {
                                      return DropdownMenuItem(
                                        child: Text(styleItem),
                                        value: styleItem,
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        artStyleValue = newValue!;
                                        print(artStyleValue);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  //!!Test image value

                  //How to use image from decode
                  // _base64String == null
                  //     ? Container()
                  //     : Image.memory(base64Decode(_base64String)),

                  // //! Submit button
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      width: size.width,
                      height: 45,
                      child: ElevatedButton(
                        //? variable foe submit
                        //!_image
                        //!creation_type
                        //!artDescriptionController
                        //!artStyleValue
                        //!tag
                        onPressed: () {
                          addNewPostToServer();
                          // uploadArtwork(_token);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(bgBlack),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                  color: lightPurple,
                                  width: 0.5,
                                ),
                              ),
                            )),

                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 12,
                            color: lightPurple,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
