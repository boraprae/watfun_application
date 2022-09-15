import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';

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
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: bgBlack,
        appBar: AppBar(
          backgroundColor: bgBlack,
          title: const Text(
            'WATFUN',
            style: TextStyle(
              fontStyle: FontStyle.italic,
            ),
          ),
          leading: IconButton(
            icon: SizedBox(
              width: 25,
              height: 25,
              child: Image.asset(
                'assets/img/appLogo.png',
              ),
            ),
            onPressed: () {},
          ),
        ),
        bottomNavigationBar: Container(
          color: bgBlack,
          child: const TabBar(
            indicatorColor: Colors.transparent,
            labelColor: lightPurple,
            unselectedLabelColor: Colors.white,
            tabs: [
            
              Tab(
                icon: Icon(
                  Icons.storefront_outlined,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.explore_outlined ,
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
        body: TabBarView(children: [
          //home page class
          Text("data"),
          //store page class
          Text("data"),
          //add post class
          Text("data"),
          //wallet page class
          Text("data"),
          //profile page class
          Text("data"),
        ]),
      ),
    );
  }
}
