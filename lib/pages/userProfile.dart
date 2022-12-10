import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:watfun_application/appBar.dart';
import 'dart:convert';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/widgets/postDetail.dart';
import 'package:watfun_application/pages/accountSetting.dart';
import 'package:watfun_application/pages/shared/listImg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _token = '';
  var userInfoList;
  List artworkList = [];
  // List<PhotoItem> _items = [];
  bool _waiting = true;
  bool _haveImg = false;
  bool _waitingUserData = false;
  bool _btnOnPress = false;
  String username = 'SaraYune';
  String bioText = 'Don’t follow your dream, just follow my arts';
  String profileImg = 'assets/artworksUploads/05.jpg';
  String profileCoverImg = 'assets/artworksUploads/02.jpg';

  // @override
  // void initState() {
  //   super.initState();
  //   getToken();
  // }

  final List<PhotoItem> _items = [
    PhotoItem(
      "assets/artworksUploads/01.jpg",
      "Arai",
      "Sara Yune",
      "Sep 15, 2021",
      "lineless commission for Panalee0819 thanks for commissioning",
      [
        'Anime',
        'Fanart',
      ],
      '',
    ),
    PhotoItem(
      "assets/artworksUploads/02.jpg",
      "Mai roo",
      "Stephan Seeber",
      "Sep 4, 2021",
      "lineless commission for Panalee0819 thanks for commissioning",
      [
        'Anime',
        'Fanart',
      ],
      '',
    ),
    PhotoItem(
      "assets/artworksUploads/03.jpg",
      "55555",
      "Stephan Seeber",
      "Sep 4, 2021",
      "lineless commission for Panalee0819 thanks for commissioning",
      [
        'Anime',
        'Fanart',
      ],
      '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //cover image
                Container(
                  height: 0.15 * size.height,
                  width: size.width,
                  child: Image.asset(
                    profileCoverImg,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                //User's bio
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 72, 36, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        bioText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: size.width,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            //path to setting page
                            Navigator.pushNamed(
                              context, '/profileSetting',
                              // arguments: <String, dynamic>{
                              //   'commission_offer_detail': data[index]
                              // },
                            );
                          },
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 0.04 * size.width,
                          ),
                          label: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(56, 0, 56, 0),
                  //!The _btnOnPress meaning is Commission Offer = false, Gallery = true
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _btnOnPress = false;
                          });
                        },
                        child: Text(
                          'Commission Offers ' + '15',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color:
                                _btnOnPress == false ? Colors.white : grayText,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.25,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _btnOnPress = true;
                          });
                        },
                        child: Text(
                          'Gallery ' + '3',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color:
                                _btnOnPress == true ? Colors.white : grayText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    //Divider will change if text button on press
                    children: [
                      SizedBox(
                        width: size.width * 0.5,
                        child: Divider(
                          color: _btnOnPress == false ? Colors.white : grayText,
                          thickness: _btnOnPress == false ? 5 : 1,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: size.width * 0.5,
                          child: Divider(
                            color:
                                _btnOnPress == true ? Colors.white : grayText,
                            thickness: _btnOnPress == true ? 5 : 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Gallery
                _btnOnPress == false
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: textForNoContent(),
                      )
                    : Container(
                        width: size.width,
                        height: size.height * 0.8,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                            crossAxisCount: 3,
                          ),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            // Item rendering
                            return new GestureDetector(
                              onTap: () {
                                print(index);
                                print(_items[index]);
                                // Navigator.pushNamed(context, '/artworkDetail',
                                //     arguments: <String, dynamic>{
                                //       'artwork_detail': _items[index]
                                //     });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetail(),
                                    settings:
                                        RouteSettings(arguments: _items[index]),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(_items[index].image),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
            Positioned(
              top: 0.08 * size.height,
              left: 0.35 * size.width,
              child: CircleAvatar(
                backgroundImage: AssetImage(profileImg),
                radius: 0.12 * size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget textForNoContent() {
  return const Center(
    child: Text(
      "Have no content yet",
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    ),
  );
}
