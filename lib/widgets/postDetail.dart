import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/pages/shared/listImg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class PostDetail extends StatefulWidget {
  var userData;
  PostDetail({this.userData}) {}

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  TextEditingController newComment = TextEditingController();
  int _selectedIndex = 0;

//Get artwork data
  final String _url = "http://10.0.2.2:9000/artworks";
  late Future<List> _data;
  bool _waiting = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int itemCount = 0;
  bool showTextAlert = false;
  bool selectedItem = false;
  String textAlert = 'Please select the item first';
  String selectedItemText = 'You don\'t select any gift yet.';
  String itemName = '';
  int currentItemId = 1;

  String totalComment = '0';
  String totalLikes = '1.2k';
  String username = 'SaraYune';
  String _token = "";
  var _userGiftData;

  Future showAlert(String title, String alertMessage) async {
    await showDialog(
      context: context,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = getData();
  }

  //Get Commission Offer
  Future<List> getData() async {
    Response response = await GetConnect().get(_url);
    // print(response.body);
    if (response.status.isOk) {
      setState(() {
        _waiting = false;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  void getName(String name, int id) {
    setState(() {
      itemName = name;
      currentItemId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.userData);
    final _items = ModalRoute.of(context)!.settings.arguments as PhotoItem;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgBlack,
      //?tab bar wil paste here
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/img/neonBG.jpg'))),
            ),
            Container(
              height: size.height,
              width: size.width,
              color: Colors.black.withOpacity(0.5),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 48, 0, 48),
              child: Container(
                height: size.height,
                width: size.width,
                color: Colors.black,
              ),
            ),
            BlurryContainer(
              blur: 15,
              elevation: 0,
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              width: size.width,
              height: size.height,
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const Text(
                        'Artworks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? Artwork Image
                      Container(
                        height: 0.4 * size.height,
                        width: size.width,
                        child: Image.memory(
                          base64Decode(_items.image),
                          fit: BoxFit.cover,
                        ),
                        // child: Image.network(
                        //   _items.image,
                        //   fit: BoxFit.fitWidth,
                        // ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //!-------- Paste code for go to another profile here ----
                                    },
                                    child: Row(
                                      children: [
                                        //! User Profile Image
                                        CircleAvatar(
                                          radius: 10.0,
                                          backgroundImage: AssetImage(
                                            'assets/artworksUploads/05.jpg',
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            _items.pubUsername,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _items.pubDate,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: grayText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _items.imgTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _items.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            //! User Profile Image(Comment)
                          ],
                        ),
                      ),
                    ],
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
