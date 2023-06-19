import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jeepney/screens/auth/login_page.dart';
import 'package:jeepney/widgets/drawer_widget.dart';
import 'package:jeepney/widgets/text_widget.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  String query = '';

  final queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: TextRegular(
            text: 'Jeepney Stop System', fontSize: 18, color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text(
                          'Logout Confirmation',
                          style: TextStyle(
                              fontFamily: 'QBold', fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          'Are you sure you want to Logout?',
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
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
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
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Center(
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
                      text: 'Proximity', fontSize: 14, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                      child: ListTile(
                        leading: TextBold(
                            text: 'John Doe',
                            fontSize: 14,
                            color: Colors.black),
                        trailing: TextRegular(
                            text: '60ms away',
                            fontSize: 14,
                            color: Colors.grey),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
