import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:watfun_application/appBar.dart';
import 'package:get/get.dart';

class CommissionStorage extends StatefulWidget {
  const CommissionStorage({Key? key}) : super(key: key);

  @override
  State<CommissionStorage> createState() => _CommissionStorageState();
}

class _CommissionStorageState extends State<CommissionStorage> {
  String sortingTag = 'Latest';
  final String _offerURL = "http://10.0.2.2:9000/commission_offer";
  final String _orderURL = "http://10.0.2.2:9000/commission_order";
  late Future<List> _orderData;
  late Future<List> _offerData;
  bool _waiting = true;
  bool _waitingOfferData = true;
  //get offer information by ID
  var offerDetail;
  var dataStatus = false;

  @override
  void initState() {
    super.initState();
    _orderData = getData();
    _offerData = getOfferData();
  }

  //Get Commission Order
  Future<List> getData() async {
    Response response = await GetConnect().get(_orderURL);
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

  //Get commission order detail
  Future<List> getOfferData() async {
    Response response = await GetConnect().get(_offerURL);
    //  print(response.body);
    if (response.status.isOk) {
      setState(() {
        _waitingOfferData = false;
        dataStatus = true;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  Future filterOrderList(id) async {
    List offerData = await _offerData;
    List summary = [];
    for (int i = 0; i < offerData.length; i++) {
      if (id == offerData[i]["id"]) {
        summary.add(offerData[i]);
      }
    }
    //has one
    // setState(() {
    //   offerDetail = summary;
    //   dataStatus = true;
    // });
    return summary;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //** Commission Offer Widget**
    Widget commissionOffer(index, dataN) {
      //This function seems has a problem
      // filterOrderList(data[index]['offer_id_commission']);
      //assign offer detail
      offerDetail = filterOrderList(dataN[index]['offer_id_commission']);
      return dataStatus == false
          ? const Center(
              child: const CircularProgressIndicator(
              backgroundColor: bgBlack,
              color: purpleG,
            ))
          : FutureBuilder(
              future: offerDetail!,
              builder: (context, snapshot) {
                late List data = snapshot.data as List;
                // print(data);
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        Container(
                          width: size.width - 200,
                          height: size.height * 0.25,
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
                                    data[0]["offer_image_base64"],
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        //Todo: Map with data from server
                        Positioned(
                          bottom: 0,
                          child: BlurryContainer(
                            blur: 5,
                            elevation: 0,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            width: size.width - 200,
                            color: Colors.black.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //user image profile
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundImage: AssetImage(
                                          data[0]["profile_image_path"],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data[0]['username'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 6,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data[0]['offer_title'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 8,
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
                                          Text(
                                            'Price',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 6,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            data[0]['offer_price'] + " Baht",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
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
                                      Navigator.pushNamed(
                                          context, '/commissionProgress',
                                          arguments: <String, dynamic>{
                                            'order_detail': data[0],
                                            'order_info': dataN[index],
                                          });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: size.width - 270,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
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
                                              'View Progress',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
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

    return SingleChildScrollView(
      child: Column(
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
                        const Text(
                          'Your Commission Order',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Sorting by: ' + sortingTag,
                          style: const TextStyle(
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
                //** List of commission order **//
                _waiting
                    ? Center(
                        child: const CircularProgressIndicator(
                        backgroundColor: bgBlack,
                        color: purpleG,
                      ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: size.height * 0.35,
                          width: size.width,
                          child: FutureBuilder(
                              future: _orderData,
                              builder: (context, snapshot) {
                                late List data = snapshot.data as List;
                                if (snapshot.hasData) {
                                  return data.length == 0
                                      ? Center(
                                          child: Text(
                                            "No have any order :<",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            //Invalid value: Only valid value is 0: 1
                                            return commissionOffer(index, data);
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
                      ),
                //! Customer Commission Order
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Customer Commission Order',
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
                //** List of commission order **//
                _waiting
                    ? Center(
                        child: const CircularProgressIndicator(
                        backgroundColor: bgBlack,
                        color: purpleG,
                      ))
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: size.height * 0.35,
                          width: size.width,
                          child: FutureBuilder(
                              future: _orderData,
                              builder: (context, snapshot) {
                                late List data = snapshot.data as List;
                                if (snapshot.hasData) {
                                  return data.length == 0
                                      ? Center(
                                          child: Text(
                                            "No have any order :<",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            //Invalid value: Only valid value is 0: 1
                                            return commissionOffer(index, data);
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
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
