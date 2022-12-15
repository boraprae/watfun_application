import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:get/get.dart';

class EditCommissionDetail extends StatefulWidget {
  const EditCommissionDetail({Key? key}) : super(key: key);

  @override
  State<EditCommissionDetail> createState() => _EditCommissionDetailState();
}

class _EditCommissionDetailState extends State<EditCommissionDetail> {
  int itemCount = 0;
  bool showTextAlert = false;
  bool selectedItem = false;
  String itemName = '';
  int currentItemId = 1;
  String _token = "";

  final String _orderURL = "http://10.0.2.2:9000/commission_order";
  final String _offerURL = "http://10.0.2.2:9000/commission_offer";

  TextEditingController customerReqController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController resultController = TextEditingController();

  Future updateDataToServer(context, offerID) async {
    print("offer id: " + offerID);
    //TODO: Check if no have new image
    //TODO: If change the email
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    Response response = await GetConnect().patch(
        _offerURL + "/" + offerID.toString(),
        jsonEncode(<String, dynamic>{
          "offer_title": titleController.text,
          "offer_description": descriptionController.text,
          "offer_price": priceController.text,
          "offer_result": resultController.text,
        }));

    setState(() {
      // usernameController.clear();
      // emailController.clear();
      // paymentController.clear();
    });

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Success",
      text: "Update Successfully.",
      confirmBtnText: "OK",
      confirmBtnColor: lightGray,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // print(data['owner_info']);
    titleController.text =
        data["commission_offer_detail"]["offer_title"].toString();
    priceController.text =
        data["commission_offer_detail"]["offer_price"].toString();
    descriptionController.text =
        data["commission_offer_detail"]["offer_description"].toString();
    resultController.text =
        data["commission_offer_detail"]["offer_result"].toString();
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
                          'Commission Offer Detail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
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
                                                      style: const TextStyle(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                const Text(
                                  'Title',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  controller: titleController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 16),
                                  child: TextFormField(
                                    controller: descriptionController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        )),
                                  ),
                                ),
                                const Text(
                                  'Price ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  controller: priceController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'The product',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  controller: resultController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      )),
                                ),
                                // Divider(color: grayText),
                                const SizedBox(
                                  width: 10,
                                ),
                                //! Place order button
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: GestureDetector(
                                    onTap: () {
                                      // placeCommissionOrder(
                                      //   context,
                                      //   data["commission_offer_detail"]["id"],
                                      // );
                                      updateDataToServer(
                                          context,
                                          data["commission_offer_detail"]
                                              ["id"].toString());
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              'Submit',
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
