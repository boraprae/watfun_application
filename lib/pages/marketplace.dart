import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/appBar.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/widgets/commissionOffer.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({Key? key}) : super(key: key);

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  //variable for testing
  String sortingTag = 'Lastest';
  List artworkCategory = [
    {'name': 'All Category', 'isOnClicked': true},
    {'name': 'Realism', 'isOnClicked': false},
    {'name': 'Photorealism', 'isOnClicked': false},
    {'name': 'Expressionism', 'isOnClicked': false},
    {'name': 'Impressionism', 'isOnClicked': false},
    {'name': 'Abstract', 'isOnClicked': false},
    {'name': 'Surrealism', 'isOnClicked': false},
    {'name': 'Pop', 'isOnClicked': false},
    {'name': 'Oil', 'isOnClicked': false},
    {'name': 'Watercolour ', 'isOnClicked': false},
  ];
  //Test Data
  List commissionInfo = [
    {
      'id': 0,
      'creatorName': 'SaraYune',
      'title': 'I will create the custom girl for you.',
      'price': 350,
      'userImgPath': 'assets/artworksUploads/00.jpg',
      'coverImgPath': 'assets/artworksUploads/00.jpg',
    },
    {
      'id': 1,
      'creatorName': 'SaraYune',
      'title': 'I will create the custom girl for you.',
      'price': 350,
      'userImgPath': 'assets/artworksUploads/00.jpg',
      'coverImgPath': 'assets/artworksUploads/01.jpg',
    },
    {
      'id': 2,
      'creatorName': 'SaraYune',
      'title': 'I will create the custom girl for you.',
      'price': 350,
      'userImgPath': 'assets/artworksUploads/00.jpg',
      'coverImgPath': 'assets/artworksUploads/02.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //** Commission Offer Widget**
    Widget commissionOffer(index) {
      return Stack(
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
                child: Image.asset(
                  commissionInfo[index]['coverImgPath'],
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: BlurryContainer(
              blur: 5,
              elevation: 0,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                          backgroundImage: AssetImage(
                            commissionInfo[index]['userImgPath'],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              commissionInfo[index]['creatorName'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              commissionInfo[index]['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              commissionInfo[index]['price'].toString() +
                                  " Baht",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //** Order Commission Button **//
                    GestureDetector(
                      onTap: () {
                        // Navigator.pushNamed(
                        //   context,
                        //   '/separate',
                        //   arguments: <String, dynamic>{
                        //     'name': artworkCategory[index],
                        //   },
                        // );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width - 100,
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
      );
    }

//*** Category Filter Button ****
    Widget listViewChannel(index) {
      return GestureDetector(
        onTap: () {
          // Navigator.pushNamed(
          //   context,
          //   '/separate',
          //   arguments: <String, dynamic>{
          //     'name': artworkCategory[index],
          //   },
          // );
          setState(() {
            artworkCategory[index]['isOnClicked'] = true;
            for (int i = 0; i < artworkCategory.length; i++) {
              if (i != index) {
                artworkCategory[i]['isOnClicked'] = false;
              }
            }
            //print for test the value
            print(artworkCategory[index]['name']);
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: artworkCategory[index]['isOnClicked']
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
                          artworkCategory[index]['name'],
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
                          artworkCategory[index]['name'],
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
    return Column(
      children: [
        CustomAppBar(),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover Commission Offers',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Sorting by: ' + sortingTag,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  //** Sorting Button **//
                  Container(
                    height: 45,
                    width: 45,
                    child: RaisedButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                btnTopLeft,
                                btnTopRight,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 45.0, minHeight: 45.0),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.sort_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //** End of Sorting Button **//
                ],
              ),
              //** Searching Button **//
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF535353).withOpacity(0.38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    onPressed: () {
                      // Respond to button press
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
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: artworkCategory.length,
                    itemBuilder: (context, index) {
                      return listViewChannel(index);
                    }),
              ),
              SizedBox(
                height: size.height * 0.58,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: commissionInfo.length,
                    itemBuilder: (context, index) {
                      return commissionOffer(index);
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
