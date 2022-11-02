import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';

class OrderCommission extends StatefulWidget {
  const OrderCommission({Key? key}) : super(key: key);

  @override
  State<OrderCommission> createState() => _OrderCommissionState();
}

class _OrderCommissionState extends State<OrderCommission> {
  int itemCount = 0;
  bool showTextAlert = false;
  bool selectedItem = false;
  String textAlert = 'Please select the item first';
  String selectedItemText = 'You don\'t select any gift yet.';
  String itemName = '';
  int currentItemId = 1;

  String totalComment = '0';
  String totalLikes = '1.2k';
  String username = 'SaraYune';
  String _token = "";
  TextEditingController customerReqController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
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
                        Text(
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
                            child: Image.asset(
                              'assets/artworksUploads/00.jpg',
                              fit: BoxFit.cover,
                            )),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Container(
                                  //   color: pinkG,
                                  //   padding: EdgeInsets.all(6.0),
                                  //   child: Text(
                                  //     'Amime',
                                  //     style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 8,
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  // Container(
                                  //   color: pinkG,
                                  //   padding: EdgeInsets.all(6.0),
                                  //   child: Text(
                                  //     'HalfBodyPaint',
                                  //     style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 8,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
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
                                              'assets/img/seraphine.jpg',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              'SeraYune',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Sep 4, 2021',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'I will create the custom girl for you.',
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
                                  'The half body of anime girl for Panalee0819 thanks for commissioning',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                'Price ' + "350" + ' Baht',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '- Bust Size',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '- Color',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '- 1 Character',
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
                                    contentPadding:
                                        const EdgeInsets.all(16),
                                    hintText:
                                        'Describe your commission request....',
                                    hintStyle: const TextStyle(
                                      color: grayText,
                                      fontSize: 12,
                                    ),
                                  ),
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
