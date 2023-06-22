import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jeepney/services/distance_calculations.dart';
import 'package:jeepney/widgets/drawer_widget.dart';
import 'package:jeepney/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

import '../plugin/location.dart';
import '../widgets/toast_widget.dart';
import 'auth/login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();

    Geolocator.getCurrentPosition().then((position) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'location': {'lat': position.latitude, 'long': position.longitude},
      });

      setState(() {
        myLat = position.latitude;
        myLong = position.longitude;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
    getData();
  }

  var _value = false;

  bool hasLoaded = true;

  double myLat = 0;
  double myLong = 0;

  double lat = 0;
  double long = 0;

  getData() {
    FirebaseDatabase.instance
        .ref('gpsCoordinates')
        .onValue
        .listen((DatabaseEvent event) async {
      final dynamic data = event.snapshot.value;

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        lat = data['latitude'];
        long = data['longitude'];
        hasLoaded = true;
      });
    });
  }

  String query = '';

  final queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showToast('Application refreshed');
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                          'Delete Account Confirmation',
                          style: TextStyle(
                              fontFamily: 'QBold',
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        content: const Text(
                          'Are you sure you want to delete your Account?',
                          style: TextStyle(fontFamily: 'QRegular'),
                        ),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                  fontFamily: 'QRegular',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser!.delete();

                              showToast(
                                  'Your account has been permanently deleted');

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                  fontFamily: 'QRegular',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ));
            },
            child: const Icon(Icons.no_accounts_outlined),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: TextRegular(
            text: 'Jeepney Stop System', fontSize: 18, color: Colors.white),
        centerTitle: true,
        actions: [
          StreamBuilder<DocumentSnapshot>(
              stream: userData,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox();
                }
                dynamic data = snapshot.data;
                return Container(
                  padding: const EdgeInsets.only(right: 20),
                  width: 50,
                  child: SwitchListTile(
                    activeColor: Colors.white,
                    value: data['isActive'],
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                        if (_value == true) {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'isActive': true,
                          });
                          showToast(
                              'Status: Active\nJeepney Drivers will now see your location');
                        } else {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'isActive': false,
                          });
                          showToast(
                              'Status: Inactive\nJeepney Drivers will not be able to see your location');
                        }
                      });
                    },
                  ),
                );
              }),
        ],
      ),
      body: hasLoaded
          ? Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 325,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(100)),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: 'Search Jeepney',
                          hintStyle: TextStyle(fontFamily: 'QRegular'),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                      controller: queryController,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextBold(
                            text: 'Jeepney Driver',
                            fontSize: 16,
                            color: Colors.black),
                        TextRegular(
                            text: 'Proximity',
                            fontSize: 14,
                            color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .where('usertype', isEqualTo: 'Driver')
                          .where('isActive', isEqualTo: true)
                          .where('name',
                              isGreaterThanOrEqualTo:
                                  toBeginningOfSentenceCase(query))
                          .where('name',
                              isLessThan:
                                  '${toBeginningOfSentenceCase(query)}z')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return const Center(child: Text('Error'));
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            )),
                          );
                        }

                        final data = snapshot.requireData;
                        return Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                                itemCount: data.docs.length,
                                itemBuilder: (context, index) {
                                  return calculateDistance(
                                              myLat, myLong, lat, long) <
                                          0.20
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: Card(
                                            child: ListTile(
                                              leading: TextBold(
                                                  text: data.docs[index]
                                                      ['name'],
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              trailing: TextRegular(
                                                  text:
                                                      '${calculateDistance(myLat, myLong, lat, long).toStringAsFixed(2)}kms away',
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        )
                                      : const SizedBox();
                                }),
                          ),
                        );
                      })
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
