import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:get/get.dart';

class CommissionProgress extends StatefulWidget {
  const CommissionProgress({Key? key}) : super(key: key);

  @override
  State<CommissionProgress> createState() => _CommissionProgressState();
}

class _CommissionProgressState extends State<CommissionProgress> {
  int itemCount = 0;
  bool showTextAlert = false;
  String itemName = '';
  int currentItemId = 1;

  String totalComment = '0';
  String totalLikes = '1.2k';
  String username = 'SaraYune';
  String _token = "";
  bool _editStatus = true;

  TextEditingController customerReqController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // print(data['order_detail']);
    print(data['order_info']);
    return Scaffold(
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
              child: SingleChildScrollView(
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
                          'Commission Progress',
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
                        //Todo: Update Commission Image
                        Container(
                            height: 0.4 * size.height,
                            width: size.width,
                            child: Image.memory(
                              base64Decode(
                                  data["order_detail"]["offer_image_base64"]),
                              fit: BoxFit.cover,
                            )),
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
                                      //Todo: Update User Profile
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 10.0,
                                            backgroundImage: AssetImage(
                                              data["order_detail"]
                                                  ["profile_image_path"],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              data["order_detail"]["username"],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Todo: Add date
                                    Text(
                                      "Ordered on: " +
                                          data["order_info"]["order_date"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                data["order_detail"]["offer_title"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  data["order_detail"]["offer_description"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                'Price ' +
                                    data["order_detail"]["offer_price"]
                                        .toString() +
                                    ' Baht',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Customer Request",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  data['order_info']
                                      ['order_request_description'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Commission Progress Status",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                data['order_info']['progress_percentage']
                                        .toString() +
                                    "%",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Payment Status",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              data['order_info']['payment_status'] == false
                                  ? Text(
                                      "Unpaid",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  : Text(
                                      "Paid",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   '/separate',
                                    //   arguments: <String, dynamic>{
                                    //     'name': artworkCategory[index],
                                    //   },
                                    // );
                                    setState(() {
                                      _editStatus = false;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: size.width - 50,
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
                                            'Edit Progress',
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
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
