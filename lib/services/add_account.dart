import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addAccount(email, password, usertype, name) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  final json = {
    'email': email,
    'password': password,
    'dateTime': DateTime.now(),
    'coordinates': {'lat': 0.00, 'long': 0.00},
    'id': FirebaseAuth.instance.currentUser!.uid,
    'usertype': usertype,
    'name': name
  };

  await docUser.set(json);
}
