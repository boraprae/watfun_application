import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/artworkPost/postDetail.dart';
import 'package:watfun_application/userProfile/accountSetting.dart';
import 'package:watfun_application/userProfile/shared/listImg.dart';
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
  List<PhotoItem> _items = [];
  bool _waiting = true;
  bool _haveImg = false;
  bool _waitingUserData = false;

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
    getArtworkAPI(_token);
  }

  void getUserDataAPI(String token) async {
    http.Response userInfoResponse = await getUserInfo(token);
    //ToDo: Change _waitingUserData to false after connect to server
    setState(() {
      userInfoList = jsonDecode(userInfoResponse.body);
      _waitingUserData = true;
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

  void getArtworkAPI(String token) async {
    http.Response artworksResponse = await getArtworks(token);
    artworkList = jsonDecode(artworksResponse.body);

    if (artworkList.length > 0) {
      _haveImg = true;
      for (int i = 0; i < artworkList.length; i++) {
        String date = artworkList[i]['date_time'].toString();
        List pubDate = date.split(' ');

        _items.add(
          PhotoItem(
              'http://10.0.2.2:3000' + artworkList[i]['image_path'],
              artworkList[i]['title'],
              artworkList[i]['username'],
              pubDate[0],
              artworkList[i]['description'],
              artworkList[i]['tags_name'],
              artworkList[i]['type_name']),
        );
      }
      _waiting = false;
    } else {
      print("No have img");
      _haveImg = false;
      totalLikes = 0;
    }
  }

  Future<http.Response> getArtworks(String token) {
    return http.get(
      Uri.parse('http://10.0.2.2:3000/api/profile/artwork'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _waitingUserData
        ? Center(
            child: const CircularProgressIndicator(
            backgroundColor: bgBlack,
            color: purpleG,
          ))
        : SingleChildScrollView(
            child: Container(
              color: bgBlack,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //cover image
                      Container(
                        height: 0.15 * size.height,
                        width: size.width,
                        child: Image.network(
                          'http://10.0.2.2:3000' + userInfoList['cover_image'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      //User's stat
                      Padding(
                        padding: const EdgeInsets.fromLTRB(180, 0, 36, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textForm(
                                _items.length.toStringAsFixed(0), 'Artworks'),
                            textForm(totalLikes.toStringAsFixed(0), 'Likes'),
                            textForm(
                                totalFollowing.toStringAsFixed(0), 'Follower'),
                            textForm(
                                totalFollower.toStringAsFixed(0), 'Following'),
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
                              userInfoList['username'],
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
                              userInfoList['bio'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UNIQUE',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        userInfoList['tags'].toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 0.3 * size.width,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BADGES',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        ':X',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              width: size.width,
                              child: OutlineButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AccountSetting()),
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
                      _haveImg
                          ? _waiting
                              ? Center(
                                  child: const CircularProgressIndicator(
                                  backgroundColor: bgBlack,
                                  color: purpleG,
                                ))
                              : Container(
                                  width: size.width,
                                  height: size.height * 0.8,
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1,
                                      crossAxisCount: 3,
                                    ),
                                    itemCount: _items.length,
                                    itemBuilder: (context, index) {
                                      // Item rendering
                                      return new GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostDetail(),
                                              settings: RouteSettings(
                                                  arguments: _items[index]),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  _items[index].image),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                          : Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 0.1 * size.height,
                                  ),
                                  Icon(
                                    Icons.no_photography,
                                    color: Colors.grey,
                                    size: 0.1 * size.height,
                                  ),
                                  Text(
                                    'Doesn\'t have any artwork.',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                  Positioned(
                    top: 0.08 * size.height,
                    left: 0.05 * size.width,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage('http://10.0.2.2:3000' +
                          userInfoList['profile_image']),
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
