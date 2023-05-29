import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';

class RegisterScreen extends StatelessWidget {
  final box = GetStorage();
  late String email = '';

  late String password = '';
  late String confirmPassword = '';
  late String firstName = '';
  late String lastName = '';
  late String address = '';

  RegisterScreen({super.key});
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
                  'assets/images/veges.png',
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
            TextBold(
                text: 'Crop ', fontSize: 42, color: const Color(0xff4E7B02)),
            TextBold(
                text: 'Analytical System',
                fontSize: 42,
                color: const Color(0xff4E7B02)),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Align(
                alignment: Alignment.bottomLeft,
                child:
                    TextBold(text: 'Signup', fontSize: 18, color: Colors.black),
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
                      firstName = value;
                    }),
                    decoration: const InputDecoration(
                        prefixText: '',
                        border: InputBorder.none,
                        hintText: '    Firstname',
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
                      lastName = value;
                    }),
                    decoration: const InputDecoration(
                        prefixText: '',
                        border: InputBorder.none,
                        hintText: '    Lastname',
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
                      address = value;
                    }),
                    decoration: const InputDecoration(
                        prefixText: '',
                        border: InputBorder.none,
                        hintText: '    Address',
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
                  child: ButtonWidget(onPressed: (() {}), label: 'Signup'),
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
