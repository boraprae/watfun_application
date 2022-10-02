import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:watfun_application/userProfile/userProfile.dart';
import 'package:watfun_application/artworkPost/createNewPost.dart';
class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _onItemTapped(3); // for testing
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: bgBlack,
        //   title: const Text(
        //     'WATFUN',
        //     style: TextStyle(
        //       fontStyle: FontStyle.italic,
        //     ),
        //   ),
        //   leading: IconButton(
        //     icon: SizedBox(
        //       width: 25,
        //       height: 25,
        //       child: Image.asset(
        //         'assets/img/appLogo.png',
        //       ),
        //     ),
        //     onPressed: () {},
        //   ),
        // ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: const TabBar(
            indicatorColor: Colors.transparent,
            labelColor: purpleG,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.storefront_outlined,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.explore_outlined,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.add_box_outlined,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.folder_copy_outlined,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                ),
              ),
            ],
          ),
        ),
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
          ),
        ),
      ),
    );
  }
}
