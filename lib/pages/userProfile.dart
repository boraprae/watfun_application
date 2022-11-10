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
  double totalArtwork = 270;
  double totalLikes = 1300;
  double totalFollower = 4900;
  double totalFollowing = 512;
  String _token = '';
  var userInfoList;
  List artworkList = [];
  // List<PhotoItem> _items = [];
  bool _waiting = true;
  bool _haveImg = false;
  bool _waitingUserData = false;
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
                //User's stat
                Padding(
                  padding: const EdgeInsets.fromLTRB(180, 0, 36, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textForm(totalArtwork.toStringAsFixed(0), 'Offers'),
                      textForm(totalLikes.toStringAsFixed(0), 'Artworks'),
                      textForm(totalFollowing.toStringAsFixed(0), 'Follower'),
                      textForm(totalFollower.toStringAsFixed(0), 'Following'),
                    ],
                  ),
                ),
                //User's bio
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 18, 36, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: OutlineButton.icon(
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
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: grayText),
                Padding(
                  padding: const EdgeInsets.fromLTRB(36, 8, 36, 8),
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
                //Gallery
                Container(
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
                              settings: RouteSettings(arguments: _items[index]),
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
              left: 0.05 * size.width,
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

Widget textForm(totalNumber, typeText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          totalNumber,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
      Text(
        typeText,
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    ],
  );
}
