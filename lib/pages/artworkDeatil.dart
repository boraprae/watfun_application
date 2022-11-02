import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';

class ArtworkDetail extends StatefulWidget {
  const ArtworkDetail({Key? key}) : super(key: key);

  @override
  State<ArtworkDetail> createState() => _ArtworkDetail();
}

class _ArtworkDetail extends State<ArtworkDetail> {
  TextEditingController newComment = TextEditingController();
  
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
                                    const Text(
                                      'Sep 4, 2021',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
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
