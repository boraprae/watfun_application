import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:watfun_application/appBar.dart';
import 'package:watfun_application/constantColors.dart';

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
  // List artworkCategory = [
  //   'All Category',
  //   'Realism',
  //   'Photorealism',
  //   'Expressionism',
  //   'Impressionism',
  //   'Abstract',
  //   'Surrealism',
  //   'Pop',
  //   'Oil',
  //   'Watercolour ',
  // ];

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

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 80.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: artworkCategory.length,
                    itemBuilder: (context, index) {
                      return listViewChannel(index);
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
