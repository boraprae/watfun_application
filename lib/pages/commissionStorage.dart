import 'package:flutter/material.dart';
import 'package:watfun_application/constantColors.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:watfun_application/appBar.dart';
import 'package:get/get.dart';

class CommissionStorage extends StatefulWidget {
  const CommissionStorage({Key? key}) : super(key: key);

  @override
  State<CommissionStorage> createState() => _CommissionStorageState();
}

class _CommissionStorageState extends State<CommissionStorage> {
  String sortingTag = 'Latest';
  final String _url = "http://10.0.2.2:7000/getCommissionOffer";
  late Future<List> _data;
  bool _waiting = true;

  List artworkCategory = [
    {'name': 'All Category', 'isOnClicked': true},
    {'name': 'Realism', 'isOnClicked': false},
    {'name': 'Photorealism', 'isOnClicked': false},
    {'name': 'Expressionism', 'isOnClicked': false},
    {'name': 'Impressionism', 'isOnClicked': false},
    {'name': 'Abstract', 'isOnClicked': false},
    {'name': 'Surrealism', 'isOnClicked': false},
    {'name': 'Pop', 'isOnClicked': false},
    {'name': 'Oil', 'isOnClicked': false},
    {'name': 'Watercolour ', 'isOnClicked': false},
  ];
  //Test Data
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
  void initState() {
    super.initState();
    _data = getData();
  }

  //Get Commission Offer
  Future<List> getData() async {
    Response response = await GetConnect().get(_url);
    // print(response.body);
    if (response.status.isOk) {
      setState(() {
        _waiting = false;
      });
      return response.body;
    } else {
      throw Exception('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //** Commission Offer Widget**
    Widget commissionOffer(index) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Stack(
          children: [
            Container(
              width: size.width - 200,
              height: size.height * 0.25,
              decoration: BoxDecoration(
                color: btnDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    commissionInfo[index]['coverImgPath'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            //Todo: Map with data from server
            Positioned(
              bottom: 0,
              child: BlurryContainer(
                blur: 5,
                elevation: 0,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                width: size.width - 200,
                color: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage(
                              commissionInfo[index]['userImgPath'],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                commissionInfo[index]['creatorName'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                commissionInfo[index]['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 6,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                commissionInfo[index]['price'].toString() +
                                    " Baht",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //** Order Commission Button **//
                      GestureDetector(
                        onTap: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   '/separate',
                          //   arguments: <String, dynamic>{
                          //     'name': artworkCategory[index],
                          //   },
                          // );
                          Navigator.pushNamed(
                            context,
                            '/orderCommission',
                            // arguments: <String, dynamic>{
                            //   'commission_offer_detail': data[index]
                            // },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width - 270,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
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
                                  'View Progress',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Commission Order',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Sorting by: ' + sortingTag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    //** Sorting Button **//
                    Container(
                      height: 45,
                      width: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                         style: ElevatedButton.styleFrom( shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(0.0),),
                       
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  btnTopLeft,
                                  btnTopRight,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 45.0, minHeight: 45.0),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.sort_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** End of Sorting Button **//
                  ],
                ),
                //** List of commission order **//
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: size.height * 0.35,
                    width: size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: commissionInfo.length,
                        itemBuilder: (context, index) {
                          return commissionOffer(index);
                        }),
                  ),
                ),
                //! Customer Commission Order
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your Customer Commission Order',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Sorting by: ' + sortingTag,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    //** Sorting Button **//
                    Container(
                      height: 45,
                      width: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                         style: ElevatedButton.styleFrom( shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.all(0.0),),
                       
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  btnTopLeft,
                                  btnTopRight,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Container(
                            constraints:
                                BoxConstraints(maxWidth: 45.0, minHeight: 45.0),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.sort_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //** End of Sorting Button **//
                  ],
                ),
                //** List of commission order **//
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: size.height * 0.35,
                    width: size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: commissionInfo.length,
                        itemBuilder: (context, index) {
                          return commissionOffer(index);
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
