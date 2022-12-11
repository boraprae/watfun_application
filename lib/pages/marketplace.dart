import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watfun_application/appBar.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/widgets/commissionOffer.dart';
import 'package:get/get.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({Key? key}) : super(key: key);

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  //variable for testing
  String sortingTag = 'Latest';
  //Get User Data
  final String _url = "http://10.0.2.2:9000/commission_offer";
  final String _categoryURL = "http://10.0.2.2:9000/artworkCategory";
  final String _userURL = "http://10.0.2.2:9000/user";
  late Future<List> _data;
  late Future<List> _artworkCategory;
  late Future<List> _userInfo;
  bool _waiting = true;
  bool _waitUserInfo = false;
  String currentUser = '';
  String currentCategory = 'All Category';
  var userOwnerData;

  @override
  void initState() {
    super.initState();
    _data = getData();
    //Not check loading data yet
    _artworkCategory = getCategory();
    _userInfo = getCommissionOwnerInFo();
  }

  //Get Commission Offer
  Future<List> getData() async {
    Response response = await GetConnect().get(_url);
    //get email as a token for identify who is current user
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    // print(token);
    if (response.status.isOk) {
      setState(() {
        _waiting = false;
        currentUser = token!;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  //Get category List
  Future<List> getCategory() async {
    Response response = await GetConnect().get(_categoryURL);
    if (response.status.isOk) {
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  //Get User Data
  Future<List> getCommissionOwnerInFo() async {
    Response response = await GetConnect().get(_userURL);
    if (response.status.isOk) {
      setState(() {
        _waitUserInfo = true;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  //Filter user data from USER obj
  Future<List> filterCommissionOwner(email) async {
    List userData = await _userInfo;
    List userInfo = [];
    for (int i = 0; i < userData.length; i++) {
      if (email == userData[i]["email"]) {
        userInfo.add(userData[i]);
      }
    }
    return userInfo;
  }

  //** Commission Offer Widget**
  Widget commissionOffer(index, dataN, size, isNull) {
    //TODO: filter user data from the USER obj
    userOwnerData = filterCommissionOwner(dataN[index]["user_owner_token"]);
    if (isNull == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
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
      return _waitUserInfo == false
          ? const Center(
              child: const CircularProgressIndicator(
              backgroundColor: bgBlack,
              color: purpleG,
            ))
          : FutureBuilder(
              future: userOwnerData!,
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
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: btnDark,
                                        //ToDo: Convert to base64
                                        backgroundImage: AssetImage(
                                          data[0]['profile_image_path'],
                                        ),
                                        child: data[0]["profile_image_path"] ==
                                                    null ||
                                                data[0]["profile_image_path"] ==
                                                    ""
                                            ? Text(
                                                data[0]["username"][0]
                                                    .toString()
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Container(
                                                height: 0,
                                                width: 0,
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
                                      // print(data[index]);
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
                                              'Order Commission',
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

    //*** Category Filter Button ****
    Widget listViewChannel(index, data) {
      return GestureDetector(
        onTap: () {
          setState(() {
            data[index]['isOnClicked'] = true;
            for (int i = 0; i < data.length; i++) {
              if (i != index) {
                data[i]['isOnClicked'] = false;
              }
            }
            //print for test the value
            print(data[index]['name']);
            currentCategory = data[index]['name'];
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: data[index]['isOnClicked']
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            btnTopLeft,
                            btnTopRight,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          data[index]['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: btnDark,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          data[index]['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      );
    }

    //*** End of Category Filter Button ****
    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomAppBar(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discover Commission Offers',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                //** Searching Button **//
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF535353).withOpacity(0.38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/searchOffer');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Search",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            Icon(
                              Icons.search_rounded,
                              size: 25,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //** Category Button List**//
                SizedBox(
                  height: 80.0,
                  child: FutureBuilder(
                      future: _artworkCategory,
                      builder: (context, snapshot) {
                        late List data = snapshot.data as List;
                        if (snapshot.hasData) {
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return listViewChannel(index, data);
                              });
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
                //** Commission Offer **/
                _waiting
                    ? Center(
                        child: const CircularProgressIndicator(
                        backgroundColor: bgBlack,
                        color: purpleG,
                      ))
                    : SizedBox(
                        height: size.height * 0.58,
                        child: FutureBuilder(
                          future: _data,
                          builder: (context, snapshot) {
                            late List data = snapshot.data as List;
                            List filteredData = [];
                            if (snapshot.hasData) {
                              //Todo: make more filter if currentCategory have any change
                              //Filter data before build
                              for (int i = 0; i < data.length; i++) {
                                if (data[i]['offer_art_type'] ==
                                    currentCategory) {
                                  filteredData.add(data[i]);
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: filteredData.length,
                                      itemBuilder: (context, index) {
                                        return commissionOffer(
                                            index, filteredData, size, false);
                                      });
                                } else if (currentCategory == "All Category") {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return commissionOffer(
                                            index, data, size, false);
                                      });
                                } else {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return commissionOffer(
                                            index, data, size, true);
                                      });
                                }
                              }

                              // return ListView.builder(
                              //     scrollDirection: Axis.vertical,
                              //     itemCount: data.length,
                              //     itemBuilder: (context, index) {
                              //       return commissionOffer(index, data, size);
                              //     });
                            } else if (snapshot.hasError) {
                              return const Text('Error');
                            }
                            return const Center(
                                child: const CircularProgressIndicator(
                              backgroundColor: bgBlack,
                              color: purpleG,
                            ));
                          },
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
