import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

class CommissionProgress extends StatefulWidget {
  const CommissionProgress({Key? key}) : super(key: key);

  @override
  State<CommissionProgress> createState() => _CommissionProgressState();
}

class _CommissionProgressState extends State<CommissionProgress> {
  int itemCount = 0;
  double _currentSliderValue = 0;
  bool showTextAlert = false;
  String itemName = '';
  int currentItemId = 1;

  String _token = "";
  bool _editStatus = false;

  //! Pick image function
  File? _image;
  var _base64String;
  String artworkImage = "";

  final progressPercentController = TextEditingController();
  final String _orderURL = "http://10.0.2.2:9000/commission_order";

  Future<String> createFileFromString(base64img, context) async {
    final encodedStr = "...";
    Directory? directory;
    directory = Directory('/storage/emulated/0/Download');
    Uint8List bytes = base64.decode(base64img);
    // String dir = (await getExternalStorageDirectory())!.path;
    String dir = directory.path;

    String fullPath = '$dir/watfun.png';
    print("local file full path ${fullPath}");
    File file = File(fullPath);
    await file.writeAsBytes(bytes);
    print(file.path);

    final result = await ImageGallerySaver.saveImage(bytes);
    print(result);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Download Successful",
      text: "Please check your artwork in the gallery!",
      confirmBtnText: "OK",
      confirmBtnColor: lightGray,
    );

    return file.path;
  }

  Future updateCommissionProgress(percent, orderID, context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    if (_currentSliderValue > percent) {
      Response response = await GetConnect().patch(
        _orderURL + "/" + orderID.toString(),
        jsonEncode(<String, dynamic>{
          "progress_percentage": _currentSliderValue,
          "artwork_progress_image": artworkImage,
        }),
      );
      //reset all
      setState(() {
        //progressPercentController.clear();
        _currentSliderValue = 0.00;
      });
      //alert
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: "Success",
        text: "Update Successfully",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Warning",
        text: "Please filled the data.",
        confirmBtnText: "OK",
        confirmBtnColor: lightGray,
      );
    }
  }

  Future pickCommissionArtImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      // read picked image byte data.
      Uint8List imagebytes = await image.readAsBytes();
      // using base64 encoder convert image into base64 string.
      _base64String = base64Encode(imagebytes);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() {
        this._image = imagePermanent;
        artworkImage = _base64String;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //!Save to local storage
  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
                                          Text(
                                            "Ordered from: " +
                                                data["order_info"]
                                                        ["order_user_email"]
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Todo: Add date
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
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
                                style: const TextStyle(
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
                                  style: const TextStyle(
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
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
                              _editStatus == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: new LinearPercentIndicator(
                                        barRadius: Radius.circular(15),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                80,
                                        animation: true,
                                        lineHeight: 20.0,
                                        animationDuration: 1250,
                                        percent: data['order_info']
                                                ['progress_percentage'] /
                                            100,
                                        center: Text(
                                          data['order_info']
                                                      ['progress_percentage']
                                                  .toString() +
                                              " %",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        linearStrokeCap:
                                            LinearStrokeCap.roundAll,
                                        progressColor: purpleG,
                                        backgroundColor: Color(0xFF494949),
                                      ),
                                    )
                                  : Slider(
                                      value: _currentSliderValue,
                                      activeColor: purpleG,
                                      thumbColor: purpleG,
                                      inactiveColor: grayText,
                                      max: 100,
                                      divisions: 5,
                                      label: _currentSliderValue
                                          .round()
                                          .toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _currentSliderValue = value;
                                        });
                                      }),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Preview Picture",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _editStatus == true
                                  ? Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.3,
                                          height: size.height * 0.05,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              primary: Color(
                                                  0xFF353535), // background
                                              onPrimary: Colors.white
                                                  .withOpacity(
                                                      0.5), // foreground
                                            ),
                                            onPressed: () {
                                              pickCommissionArtImage();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.upload_file_outlined,
                                                  color: Colors.white,
                                                ),
                                                Text("Upload"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        artworkImage == "" ||
                                                artworkImage == null
                                            ? Text("")
                                            : const Text(
                                                "Upload success!",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                      ],
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        //!Image which upload from artist
                                        createFileFromString(
                                            data["order_info"]
                                                ["artwork_progress_image"],
                                            context);
                                      },
                                      child: Container(
                                        width: size.width * 0.3,
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                Icons.download_outlined,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'Download',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              Visibility(
                                visible:
                                    data['type'] == "myOrder" ? false : true,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: _editStatus == false
                                      ? GestureDetector(
                                          onTap: () {
                                            // Navigator.pushNamed(
                                            //   context,
                                            //   '/separate',
                                            //   arguments: <String, dynamic>{
                                            //     'name': artworkCategory[index],
                                            //   },
                                            // );
                                            setState(() {
                                              _editStatus = true;
                                            });
                                            // Navigator.pop(context);
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
                                                  gradient:
                                                      const LinearGradient(
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GestureDetector(
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
                                            updateCommissionProgress(
                                                data['order_info']
                                                    ['progress_percentage'],
                                                data['order_info']['id'],
                                                context);
                                            // print(
                                            //     progressPercentController.text);
                                            Navigator.pushNamed(
                                                context, "/mainMenu");
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
                                                  gradient:
                                                      const LinearGradient(
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
