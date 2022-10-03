import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:watfun_application/artworkPost/createNewPost.dart';
import 'package:watfun_application/userProfile/userProfile.dart';

class BackgroundStack extends StatelessWidget {
  const BackgroundStack({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      Size size = MediaQuery.of(context).size;
    return Stack(
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
                child: TabBarView(children: [
                  //home page class
                  Text("data"),
                  //store page class
                  Text("data"),
                  //add post class
                 CreateNewPost(),
                  //wallet page class
                  Text("data"),
                  //profile page class
                  UserProfile(),
                ]),
              ),
            ],
          );
  }
}