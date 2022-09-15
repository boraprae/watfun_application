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
    return Scaffold(
      backgroundColor: Color(0xFF161616),
      body: SafeArea(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 330,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/img/seraphine.jpg'),
                        ),
                      ),
                    ),
                    Container(
                      height: 280,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/img/leblace1.jpg'),
                        ),
                      ),
                    ),
                    Container(
                      height: 330,
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage('assets/img/missFJ.jpg'),
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }
}
