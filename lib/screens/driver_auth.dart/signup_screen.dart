import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jeepney/screens/driver_auth.dart/login_page.dart';
import 'package:jeepney/services/add_account.dart';
import 'package:jeepney/widgets/toast_widget.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';

class DriverRegisterScreen extends StatelessWidget {
  final box = GetStorage();
  late String email = '';

  late String password = '';
  late String confirmPassword = '';
  late String name = '';

  DriverRegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: (() {
                      Navigator.pop(context);
                    }),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            TextBold(text: 'Jeepney ', fontSize: 42, color: Colors.blue),
            TextBold(text: 'Stop System', fontSize: 42, color: Colors.blue),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: TextBold(
                    text: 'Signup as Driver',
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Card(
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: TextFormField(
                    onChanged: ((value) {
                      name = value;
                    }),
                    decoration: const InputDecoration(
                        prefixText: '',
                        border: InputBorder.none,
                        hintText: "    Jeepney Driver's Name",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'QRegular',
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Card(
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: TextFormField(
                    onChanged: ((value) {
                      email = value;
                    }),
                    decoration: const InputDecoration(
                        prefixText: '',
                        border: InputBorder.none,
                        hintText: '    Username',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'QRegular',
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Card(
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: TextFormField(
                    obscureText: true,
                    onChanged: ((value) {
                      password = value;
                    }),
                    decoration: const InputDecoration(
                        prefixText: '',
                        border: InputBorder.none,
                        hintText: '    Password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'QRegular',
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Card(
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: TextFormField(
                    obscureText: true,
                    onChanged: ((value) {
                      confirmPassword = value;
                    }),
                    decoration: const InputDecoration(
                        prefixText: '',
                        border: InputBorder.none,
                        hintText: '    Confirm Password',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'QRegular',
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 150,
                  child: ButtonWidget(
                      onPressed: (() async {
                        if (password != confirmPassword) {
                          showToast('Password do not match!');
                        } else {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: '$email@driver.com',
                                    password: password);
                            addAccount(email, password, 'Driver', name);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => DriverLoginScreen()));
                            showToast('Account created succesfully!');
                          } catch (e) {
                            showToast(e.toString());
                          }
                        }
                      }),
                      label: 'Signup'),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
