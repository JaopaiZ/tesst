import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import '../curinfo2.dart';
import '../login.dart';
import 'loginsuccess.dart';

class ReservationNav extends StatefulWidget {
  @override
  _ReservationNav createState() => _ReservationNav();
  static const String routeName = '/ReservationNav'; // เพิ่มตรงนี้
}

class _ReservationNav extends State<ReservationNav> {
  final authen = FirebaseAuth.instance;
  String usernameData = FirebaseAuth.instance.currentUser!.email!;
  final PageController _controller = PageController(initialPage: 0);
  final List<String> _tabs = ['1', '2'];
  int _selectedIndex = 0;

  Future<void> _onPinSuccess() async {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สวัสดีคุณ $usernameData'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authen.signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              });
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.lock),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => CreatePinPage()),
          //     );
          //   },
          // ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: PageView(
                      controller: _controller,
                      children: [
                        Image.network(
                          'https://www.superrichthailand.com/uploads/images/cd8811cfdce0375be9a599e6c19922f11669868861014.jpeg',
                          fit: BoxFit.cover,
                        ),
                        Image.network(
                          'https://superrichrate2.ztidev.com/superRich/download?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBlclJpY2giLCJleHAiOjQ4MzczNDM4MzUsImlhdCI6MTY4MTY0ODYzNSwia2V5IjoiajFTOHNkR3hyeHpKcnNad3NIU2NHd1BjIn0.biWX-uWdD01OXTnZBFL_GZJwqvwmRt0cs5-GB0kLRQY&file=4d46819f-b327-4db8-9740-da53feb28aeb1676947947227.jpg',
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: GestureDetector(
                            onTap: () {
                              _selectedIndex = index;
                              _controller.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 10,
                              width: _selectedIndex == index ? 10 : 10,
                              decoration: BoxDecoration(
                                color: _selectedIndex == index
                                    ? Colors.black
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.white,
          ),
          SizedBox(
            //Box1
            height: 300,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1, // Add a border
                ),
              ),
              elevation: 8, // Add a shadow
              child: InkWell(
                onTap: () {
                  // Do something when the ListTile is tapped
                },
                child: Container(
                  child: ListTile(
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CurInfo2()));
                    },
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
                    dense: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("getCurrency")
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    final documentHeader = snapshot.data!.docs;
                                    final agencySPO = documentHeader[7]
                                        ["agency"]; //index document

                                    final curIndex0 = agencySPO[0]
                                        ["cur"]; //index agency with map[]
                                    final cur_SPO_USA = (curIndex0);

                                    return (Row(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Currency%2FTH.png?alt=media&token=0dfc94dd-60cd-4dba-9e0d-f5408da39d5b',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "จาก THB",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ));
                                  }
                                }),
                          ],
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Column(
                          children: [
                            Row(children: [
                              ClipOval(
                                child: Image.network(
                                  'https://firebasestorage.googleapis.com/v0/b/currencyexchangebc.appspot.com/o/IMG_Currency%2FUSD.png?alt=media&token=97b728ff-edcb-42f4-9b31-138298453e83',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "ไปยัง USD ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            Row(
                              children: [
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("getCurrency")
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        final document = snapshot.data!.docs;
                                        final agencySPO = document[7]
                                            ["agency"]; //index document

                                        final dem1Index0 = agencySPO[0]
                                            ["dem1"]; //index agency with map[]
                                        final parsedDem1_SPO_USA = (dem1Index0);

                                        final buyIndex0 = agencySPO[0]
                                            ["buy"]; //index agency with map[]
                                        final parsedBuy_SPO_USA = (buyIndex0);

                                        final sellIndex0 = agencySPO[0]
                                            ["sell"]; //index agency with map[]
                                        final parsedSell_SPO_USA = (sellIndex0);

                                        return Row(
                                          children: [
                                            Text(
                                              parsedDem1_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 105),
                                            Text(
                                              parsedBuy_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 40),
                                            Text(
                                              parsedSell_SPO_USA,
                                              //"dem1: ${document["agency"][0]["dem1"]}",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}


// PAGE ReservationNav!!
//class ReservationNav extends StatelessWidget {}
