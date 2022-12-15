import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:get/get.dart';

class OrderCommission extends StatefulWidget {
  const OrderCommission({Key? key}) : super(key: key);

  @override
  State<OrderCommission> createState() => _OrderCommissionState();
}

class _OrderCommissionState extends State<OrderCommission> {
  int itemCount = 0;
  bool showTextAlert = false;
  bool selectedItem = false;
  String itemName = '';
  int currentItemId = 1;

  String _token = "";

  final String _orderURL = "http://10.0.2.2:9000/commission_order";
  TextEditingController customerReqController = TextEditingController();

  Future placeCommissionOrder(context, commissionID) async {
    //get current date
    String currentDate = DateFormat("MMM dd, yyyy").format(DateTime.now());
    //get email as a token for identify who is current user
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    if (customerReqController.text != "") {
      Response response = await GetConnect().post(
        _orderURL,
        jsonEncode(<String, dynamic>{
          "order_date": currentDate,
          "order_request_description": customerReqController.text,
          "payment_status": false,
          "progress_status": false,
          "progress_percentage": 0,
          "order_user_email": token,
          "offer_id_commission": commissionID,
        }),
      );
      print(response.statusCode);
      //reset all
      setState(() {
        customerReqController.clear();
      });
      //alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Success",
        text: "Your order already place!",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Warning",
        text: "Please describe your request.",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // print(data['owner_info']);
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
                          'Commisson Offer Detail',
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
                              base64Decode(data["commission_offer_detail"]
                                  ["offer_image_base64"]),
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
                                          //convert to base64 format
                                          data['owner_info'][
                                                          "profile_image_path"] ==
                                                      null ||
                                                  data['owner_info'][
                                                          "profile_image_path"] ==
                                                      ""
                                              ? CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: btnDark,
                                                  //ToDo: Convert to base64
                                                  child: Text(
                                                    data['owner_info']
                                                            ["username"][0]
                                                        .toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ))
                                              : CircleAvatar(
                                                  backgroundColor: btnDark,
                                                  radius: 10.0,
                                                  backgroundImage: MemoryImage(
                                                      base64Decode(data[
                                                              'owner_info'][
                                                          "profile_image_path"]))),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              data['owner_info']['username'],
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
                                      data["commission_offer_detail"]
                                          ["offer_create_date"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                data["commission_offer_detail"]["offer_title"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                                child: Text(
                                  data["commission_offer_detail"]
                                      ["offer_description"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                'Price ' +
                                    data["commission_offer_detail"]
                                            ["offer_price"]
                                        .toString() +
                                    ' Baht',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                //Todo: Make a dynamic result
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "The product: " +
                                          data["commission_offer_detail"]
                                              ["offer_result"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Divider(color: grayText),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: size.width - 50,
                                height: 100,
                                //* Input the req of commission
                                child: TextField(
                                  controller: customerReqController,
                                  maxLines: 5, // <-- SEE HERE
                                  minLines: 1,

                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText:
                                        'Describe your commission request....',
                                    hintStyle: const TextStyle(
                                      color: grayText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              //! Place order button
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    placeCommissionOrder(
                                      context,
                                      data["commission_offer_detail"]["id"],
                                    );
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   '/separate',
                                    //   arguments: <String, dynamic>{
                                    //     'name': artworkCategory[index],
                                    //   },
                                    // );
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
                                            'Place Order',
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
