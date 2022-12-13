import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 220),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(18)),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/img/seraphine.jpg'),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.3,
                    width: size.width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/img/leblace1.jpg'),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(18)),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/img/missFJ.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BlurryContainer(
              blur: 25,
              width: size.width,
              height: size.height,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WATFUN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Best community to find your style and shared your artworks!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.55,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: size.width,
                        height: 0.055 * size.height,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signIn');
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width,
                      height: 0.055 * size.height,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signUp');
                        },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.white, width: 1),
                          primary: Colors.transparent,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 220),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(18)),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/img/seraphine.jpg'),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.33,
                    width: size.width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/img/leblace1.jpg'),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.4,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(18)),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage('assets/img/missFJ.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
