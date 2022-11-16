import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/appBar.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/pages/searchingOffer.dart';
import 'package:get/get.dart';

class DiscoverArts extends StatefulWidget {
  const DiscoverArts({Key? key}) : super(key: key);

  @override
  State<DiscoverArts> createState() => _DiscoverArtsState();
}

class _DiscoverArtsState extends State<DiscoverArts> {
  //variable for testing
  String sortingTag = 'Latest';
  //Get User Data
  final String _url = "http://10.0.2.2:9000/artworks";
  final String _categoryURL = "http://10.0.2.2:9000/artworkCategory";
  late Future<List> _data;
  late Future<List> _artworkCategory;
  bool _waiting = true;

  @override
  void initState() {
    super.initState();
    _data = getData();
    //Not check loading data yet
    _artworkCategory = getCategory();
  }

  //Get Artwork Data
  Future<List> getData() async {
    Response response = await GetConnect().get(_url);
    print(response.body);
    if (response.status.isOk) {
      setState(() {
        _waiting = false;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  //Get category List
  Future<List> getCategory() async {
    Response response = await GetConnect().get(_categoryURL);
    print(response.body);
    if (response.status.isOk) {
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //**Artwork Widget**
    Widget artworkWidget(index, data) {
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
                      base64Decode(data[index]['art_image_base64']),
                      fit: BoxFit.cover),
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
                              data[index]['profile_image_path'],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index]['username'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                data[index]['art_title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //** View Button **//
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   '/separate',
                          //   arguments: <String, dynamic>{
                          //     'name': artworkCategory[index],
                          //   },
                          // );
                          Navigator.pushNamed(context, '/artworkDetail',
                              arguments: <String, dynamic>{
                                'artwork_detail': data[index]
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width - 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
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
                                  'View',
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
    }

//*** Category Filter Button ****
    Widget listViewChannel(index, data) {
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
            data[index]['isOnClicked'] = true;
            for (int i = 0; i < data.length; i++) {
              if (i != index) {
                data[i]['isOnClicked'] = false;
              }
            }
            //print for test the value
            print(data[index]['name']);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Discover Artworks',
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
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.all(0.0),
                        ),
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
                        // Jump to Searching Page
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
                //**Artwork View */
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
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return artworkWidget(index, data);
                                    });
                              } else if (snapshot.hasError) {
                                return const Text('Error');
                              }
                              return const CircularProgressIndicator();
                            }),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
