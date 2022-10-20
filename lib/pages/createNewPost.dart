import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewPost extends StatefulWidget {
  const CreateNewPost({Key? key}) : super(key: key);

  @override
  _CreateNewPostState createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  TextEditingController artTitleController = TextEditingController();
  TextEditingController artDescriptionController = TextEditingController();
  TextEditingController artTagController = TextEditingController();
  List tags = [];
  File? _image;
  var dropdownvalue = 'Select style of arts';
  String _token = "";
  late BuildContext _context;
  // Future<http.Response> upload(String token, { body }) {
  //   return http.post(
  //     Uri.parse('http://10.0.2.2:3000/api/uploadArtwork'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': token,
  //     },
  //     body: body,
  //   );
  // }

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

  Future<http.StreamedResponse> uploadImage(filename, url, token) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', filename));
    request.headers['Authorization'] = token;
    request.fields['title'] = artTitleController.text;
    request.fields['description'] = artDescriptionController.text;
    if (dropdownvalue != "Select style of arts") {
      request.fields['art_type'] = dropdownvalue;
    }
    if (tags.length != 0) {
      request.fields['tags'] = tags.join(',');
    }

    print(request.fields.entries);
    var res = await request.send();
    return res;
  }

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
  }

  void uploadArtwork(String token) async {
    String apiUrl = "http://10.0.2.2:3000/api/uploadArtwork";

    if (_image == null) {
      return showAlert('Error', 'Please select an image');
    }

    http.StreamedResponse response =
        await uploadImage(_image!.path, apiUrl, token);

    String message = await response.stream.bytesToString();
    print('Response: ' + message);
    if (response.statusCode > 299) {
      return showAlert('Error', message);
    }

    showAlert('Success', 'Upload complete');
    setState(() {
      _image = null;
    });
  }

  //! dropdown static value

  var styleItem = [
    'Select style of arts',
    'Realism',
    'Photorealism',
    'Impressionism',
    'Abstract',
    'Surrealism',
    'Pop',
    'Oil',
    'Watercolour ',
  ];

  late Map<dynamic, dynamic> imgData;

  //! Pick image function

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        this._image = imagePermanent;
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

  Future submitData(imagePath, title, description, type, tags) async {
    print("img path:" + imagePath);
    print("title:" + title);
    print("description:" + description);
    print("type:" + type);
    print("tags:" + tags);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    Size size = MediaQuery.of(context).size;
    return Container(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                    )),
          //!Add title image area
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: artTitleController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 12.0, color: grayText),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: pinkG, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
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
                        hintStyle: TextStyle(fontSize: 12.0, color: grayText),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: pinkG, width: 0.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
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
                        value: dropdownvalue,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        selectedItemBuilder: (BuildContext context) {
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
                            dropdownvalue = newValue!;
                            print(dropdownvalue);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                //? TagFiledTag here (still cannor remove below hinttext)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    height: 70,
                    child: TextFieldTags(
                      tagsStyler: TagsStyler(
                        showHashtag: false,
                        tagMargin: const EdgeInsets.only(right: 4.0),
                        tagCancelIcon:
                            Icon(Icons.cancel, size: 15.0, color: Colors.white),
                        tagCancelIconPadding:
                            EdgeInsets.only(left: 4.0, top: 2.0),
                        tagPadding: EdgeInsets.only(
                            top: 2.0, bottom: 4.0, left: 8.0, right: 4.0),
                        tagDecoration: BoxDecoration(
                          color: pinkG,
                        ),
                        tagTextStyle: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.white),
                      ),
                      textFieldStyler: TextFieldStyler(
                        textFieldFilled: true,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        hintText: "Add your tags here",
                        hintStyle: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white.withOpacity(0.5)),
                        isDense: false,
                        textFieldFocusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: pinkG, width: 0.5),
                        ),
                        textFieldEnabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                        ),
                      ),
                      onDelete: (tag) {
                        tags.remove(tag.toString());
                        print('onDelete: $tags');
                      },
                      onTag: (tag) {
                        tags.add(tag.toString());
                        print('onTag: $tags');
                      },
                      validator: (String tag) {
                        print('validator: $tags');
                        if (tag.length > 10) {
                          return "Sorry, you can't longer than that.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                // //! Submit button
                SizedBox(
                  width: size.width,
                  height: 45,
                  child: ElevatedButton(
                    //? variable foe submit
                    //!_image
                    //!artTitleController
                    //!artDescriptionController
                    //!dropdownvalue
                    //!tag
                    onPressed: () {
                      uploadArtwork(_token);
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
