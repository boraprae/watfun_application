import 'dart:convert';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';

class CommissionOffer extends StatefulWidget {
  const CommissionOffer({Key? key}) : super(key: key);

  @override
  State<CommissionOffer> createState() => _CommissionOfferState();
}

class _CommissionOfferState extends State<CommissionOffer> {
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
                commissionInfo[0]['userImgPath'],
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
            width: size.width,
            color: Colors.black.withOpacity(0.7),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        commissionInfo[0]['coverImgPath'],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
