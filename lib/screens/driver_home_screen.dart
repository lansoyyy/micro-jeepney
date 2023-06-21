import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jeepney/services/distance_calculations.dart';
import 'package:jeepney/widgets/drawer_widget.dart';
import 'package:jeepney/widgets/text_widget.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;

import '../plugin/location.dart';
import '../widgets/toast_widget.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  @override
  void initState() {
    super.initState();
    determinePosition();

    getData();
  }

  String query = '';

  final queryController = TextEditingController();
  var _value = false;

  double lat = 0;
  double long = 0;

  bool hasLoaded = true;

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

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    return Scaffold(
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
                              'Status: Active\nPassengers will now see your location');
                        } else {
                          FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            'isActive': false,
                          });
                          showToast(
                              'Status: Inactive\nPassengers will not be able to view your location');
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
                          hintText: 'Search Passenger',
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
                            text: 'Passenger Name',
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
                          .where('usertype', isEqualTo: 'User')
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
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Card(
                                      child: ListTile(
                                        leading: TextBold(
                                            text: data.docs[index]['name'],
                                            fontSize: 14,
                                            color: Colors.black),
                                        trailing: TextRegular(
                                            text:
                                                '${calculateDistance(lat, long, data.docs[index]['location']['lat'], data.docs[index]['location']['long']).toStringAsFixed(2)}kms away',
                                            fontSize: 14,
                                            color: Colors.grey),
                                      ),
                                    ),
                                  );
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
