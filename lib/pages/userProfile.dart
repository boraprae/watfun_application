import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  List artworkList = [];
  List<PhotoItem> _items = [];

  bool _haveImg = false;
  bool _btnOnPress = false;
  String username = 'SaraYune';
  String bioText = 'Don’t follow your dream, just follow my arts';
  String profileImg = 'assets/artworksUploads/05.jpg';
  String profileCoverImg = 'assets/artworksUploads/02.jpg';

  //Get data from JSON server
  final String _userURL = "http://10.0.2.2:9000/user";
  final String _artworkURL = "http://10.0.2.2:9000/artworks";
  final String _url = "http://10.0.2.2:9000/commission_offer";
  late Future<List> _userInfo;
  late Future<List> _myArtwork;
  late Future<List> _data;
  bool _waitingUserInfo = true;
  bool _waitingArtworkInfo = true;
  bool _waiting = true;
  String currentUser = '';
  String myTotalOffer = "";

  @override
  void initState() {
    super.initState();
    _userInfo = getUserInformation();
    _myArtwork = getArtwork();
    _data = getData();
  }

  //Get Commission Offer
  Future<List> getData() async {
    //get email as a token for identify who is current user
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    Response response =
        await GetConnect().get(_url + "?user_owner_token=" + token!);

    // print(token);
    if (response.status.isOk) {
      List test = response.body;
      print(test.length);
      ;
      setState(() {
        _waiting = false;
        currentUser = token;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
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

  Future<List> getArtwork() async {
    //get email as a token for identify who is current user
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    Response response =
        await GetConnect().get(_artworkURL + "?user_email=" + token!);
    if (response.status.isOk) {
      //build the photo item list
      List artworkList = response.body;
      for (int i = 0; i < artworkList.length; i++) {
        _items.add(PhotoItem(
            artworkList[i]["art_image_base64"],
            artworkList[i]["art_title"],
            artworkList[i]["username"],
            artworkList[i]["art_created_date"],
            artworkList[i]["art_description"],
            artworkList[i]["art_type"]));
      }
      setState(() {
        _waitingArtworkInfo = false;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  //** Commission Offer Widget**
  Widget commissionOffer(
    index,
    dataN,
    size,
  ) {
    //userOwnerData = filterCommissionOwner(dataN[index]["user_owner_token"]);
    if (dataN == null || dataN == "" || dataN == []) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Text(
            "No have any offer yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return _waiting == true
          ? const Center(
              child: const CircularProgressIndicator(
              backgroundColor: bgBlack,
              color: purpleG,
            ))
          : FutureBuilder(
              future: _userInfo,
              builder: (context, snapshot) {
                late List data = snapshot.data as List;
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width,
                          height: size.height * 0.3,
                          decoration: BoxDecoration(
                            color: btnDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                  base64Decode(
                                      dataN[index]['offer_image_base64']),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: BlurryContainer(
                            blur: 5,
                            elevation: 0,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            width: size.width - 50,
                            color: Colors.black.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      data[0]["profile_image_path"] == null ||
                                              data[0]["profile_image_path"] ==
                                                  ""
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundColor: btnDark,
                                              //ToDo: Convert to base64
                                              child: Text(
                                                data[0]["username"][0]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))
                                          : CircleAvatar(
                                              radius: 20,
                                              backgroundColor: btnDark,
                                              //ToDo: Convert to base64
                                              backgroundImage: MemoryImage(
                                                base64Decode(data[0]
                                                    ['profile_image_path']),
                                              ),
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      //Todo: Change to user data
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[0]['username'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            dataN[index]['offer_title'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Price',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            dataN[index]['offer_price']
                                                    .toString() +
                                                " Baht",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //** Order Commission Button **//
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/orderCommission',
                                          arguments: <String, dynamic>{
                                            'commission_offer_detail':
                                                dataN[index],
                                            'owner_info': data[0]
                                          });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: size.width - 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                btnTopLeft,
                                                btnTopRight,
                                              ],
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: Text(
                                              'Edit Commission Offer',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error');
                }
                return const Center(
                    child: const CircularProgressIndicator(
                  backgroundColor: bgBlack,
                  color: purpleG,
                ));
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(),
          Container(
            child: FutureBuilder(
                future: _userInfo,
                builder: (context, snapshot) {
                  late List data = snapshot.data as List;
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        _waitingUserInfo
                            ? const Center(
                                child: CircularProgressIndicator(
                                backgroundColor: bgBlack,
                                color: purpleG,
                              ))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //cover image
                                  data[0]["cover_profile_image_path"] == null ||
                                          data[0]["cover_profile_image_path"] ==
                                              ""
                                      ? Container(
                                          height: 0.15 * size.height,
                                          width: size.width,
                                          child: Image.asset(
                                            "assets/img/neonBG.jpg",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        )
                                      : Container(
                                          height: 0.15 * size.height,
                                          width: size.width,
                                          child: Image.memory(
                                            base64Decode(data[0]
                                                ["cover_profile_image_path"]),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                  //User's bio
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        36, 72, 36, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //** Username */
                                        Text(
                                          data[0]["username"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        //** User Bio Text*/
                                        Text(
                                          data[0]["bio_text"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
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
                                            label: const Text(
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
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(56, 0, 56, 0),
                                    //!The _btnOnPress meaning is Commission Offer = false, Gallery = true
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _btnOnPress = false;
                                            });
                                          },
                                          child: Text(
                                            'My Commission Offers ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: _btnOnPress == false
                                                  ? Colors.white
                                                  : grayText,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.2,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _btnOnPress = true;
                                            });
                                          },
                                          child: Text(
                                            'Gallery ' +
                                                _items.length.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: _btnOnPress == true
                                                  ? Colors.white
                                                  : grayText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      //Divider will change if text button on press
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.5,
                                          child: Divider(
                                            color: _btnOnPress == false
                                                ? Colors.white
                                                : grayText,
                                            thickness:
                                                _btnOnPress == false ? 5 : 1,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: size.width * 0.5,
                                            child: Divider(
                                              color: _btnOnPress == true
                                                  ? Colors.white
                                                  : grayText,
                                              thickness:
                                                  _btnOnPress == true ? 5 : 1,
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
                                          child: _waiting
                                              ? Center(
                                                  child:
                                                      const CircularProgressIndicator(
                                                  backgroundColor: bgBlack,
                                                  color: purpleG,
                                                ))
                                              : SizedBox(
                                                  height: size.height * 0.58,
                                                  child: FutureBuilder(
                                                    future: _data,
                                                    builder:
                                                        (context, snapshot) {
                                                      late List data =
                                                          snapshot.data as List;
                                                      if (snapshot.hasData) {
                                                        return ListView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount:
                                                                data.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return commissionOffer(
                                                                index,
                                                                data,
                                                                size,
                                                              );
                                                            });
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return const Text(
                                                            'Error');
                                                      }
                                                      return const Center(
                                                          child:
                                                              const CircularProgressIndicator(
                                                        backgroundColor:
                                                            bgBlack,
                                                        color: purpleG,
                                                      ));
                                                    },
                                                  ),
                                                ),
                                        )
                                      : Container(
                                          width: size.width,
                                          height: size.height * 0.8,
                                          child: FutureBuilder(
                                            future: _userInfo,
                                            builder: (context, snapshot) {
                                              late List data =
                                                  snapshot.data as List;
                                              if (snapshot.hasData) {
                                                return data.length == 0
                                                    ? textForNoContent()
                                                    : GridView.builder(
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisSpacing: 1,
                                                          mainAxisSpacing: 1,
                                                          crossAxisCount: 3,
                                                        ),
                                                        itemCount:
                                                            _items.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          // Item rendering
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PostDetail(),
                                                                  settings: RouteSettings(
                                                                      arguments:
                                                                          _items[
                                                                              index]),
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image:
                                                                      MemoryImage(
                                                                    base64Decode(
                                                                      _items[index]
                                                                          .image,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                              } else if (snapshot.hasError) {
                                                return const Text('Error');
                                              }
                                              return const Center(
                                                  child:
                                                      const CircularProgressIndicator(
                                                backgroundColor: bgBlack,
                                                color: purpleG,
                                              ));
                                            },
                                          ),
                                        ),
                                ],
                              ),
                        Positioned(
                          top: 0.06 * size.height,
                          left: 0.35 * size.width,
                          child: data[0]["profile_image_path"] == null ||
                                  data[0]["profile_image_path"] == ""
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
                                  backgroundColor: btnDark,
                                  //ToDo: Convert to base64
                                  backgroundImage: MemoryImage(base64Decode(
                                      data[0]["profile_image_path"])),
                                  radius: 0.12 * size.width,
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
        ],
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
